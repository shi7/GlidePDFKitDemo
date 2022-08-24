//
//  MagnificationModifier.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/16.
//

import Foundation
import SwiftUI

public struct MagnificationModifier: ViewModifier {
    @State var scale: CGFloat = 1
    @State var lastScale: CGFloat = 1
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    
    private var contentSize: CGSize
    private var gotoPreviousPage: GotoPreviousPage
    private var gotoNextPage: GotoNextPage
    private var onTapped: OnTapped
    
    init(
        size: CGSize,
        gotoPreviousPage: @escaping GotoPreviousPage,
        gotoNextPage: @escaping GotoNextPage,
        onTapped: @escaping OnTapped
    ) {
        contentSize = size
        self.gotoPreviousPage = gotoPreviousPage
        self.gotoNextPage = gotoNextPage
        self.onTapped = onTapped
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            let magnificationGesture = MagnificationGesture()
                .onChanged { gesture in
                    scale = lastScale * gesture
                }
                .onEnded { _ in
                    fixOffsetAndScale(geometry: geometry)
                }
            
            let dragGesture = DragGesture()
                .onChanged { gesture in
                    var newOffset = lastOffset
                    if isScaled {
                        newOffset.width += gesture.translation.width
                    }
                    newOffset.height += gesture.translation.height
                    offset = newOffset
                }
                .onEnded { value in
                    let contentScaleHeight = (contentSize.height * getOriginalScale(geometry: geometry)) * scale
                    let turnPageThreshold = contentScaleHeight / 2
                    
                    let velocity = CGSize(
                        width: value.predictedEndLocation.x - value.location.x,
                        height: value.predictedEndLocation.y - value.location.y
                    )
                    
                    print("velocity height \(velocity.height)")
                    var isTurnPageSuccess = false
                    if (velocity.height > Constants.velocityDistanceThreshold) || (offset.height > turnPageThreshold) {
                        isTurnPageSuccess = gotoPreviousPage()
                    } else if (velocity.height < -Constants.velocityDistanceThreshold) || (offset.height < turnPageThreshold * -1) {
                        isTurnPageSuccess = gotoNextPage()
                    }
                    
                    if !isTurnPageSuccess {
                        fixOffsetAndScale(geometry: geometry)
                    }
                }
            
            content
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .scaleEffect(scale, anchor: .center)
                .offset(offset)
                // Add TapGesture to enable the gallery scroll like Page style
                .gesture(TapGesture(count: 1).onEnded { onTapped() }, including: isScaled ? .subviews : .all)
                .gesture(ExclusiveGesture(dragGesture, magnificationGesture))
                .onAppear {
                    reset()
                }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

extension MagnificationModifier {
    private enum Constants {
        static let velocityDistanceThreshold: CGFloat = 10000
        static let scalePrecision: CGFloat = 0.001
        static let minScale: CGFloat = 1
        static let maxScale: CGFloat = 4
    }
    
    var isScaled: Bool {
        scale - 1 > Constants.scalePrecision
    }
    
    private func reset() {
        scale = 1
        lastScale = 1
        offset = .zero
        lastOffset = .zero
    }
    
    private func fixOffsetAndScale(geometry: GeometryProxy) {
        let newScale = fixScale(geometry: geometry)
        let newOffset = fixOffset(geometry: geometry)
        lastScale = newScale
        lastOffset = newOffset
        withAnimation {
            offset = newOffset
            scale = newScale
        }
    }
    
    private func fixScale(geometry _: GeometryProxy) -> CGFloat{
        .minimum(.maximum(scale, Constants.minScale), Constants.maxScale)
    }
    
    private func fixOffset(geometry: GeometryProxy) -> CGSize {
        let containerSize = geometry.size
        let containerWidth = containerSize.width
        let containerHeight = containerSize.height
        
        let originalScale = getOriginalScale(geometry: geometry)
        let contentScaleWidth = (contentSize.width * originalScale) * scale
        
        var width: CGFloat = .zero
        if contentScaleWidth > containerWidth {
            let widthLimit = (contentScaleWidth - containerWidth) / 2
            
            width = offset.width > 0 ?
                .minimum(widthLimit, offset.width) :
                .maximum(-widthLimit, offset.width)
        }
        
        let contentScaleHeight = (contentSize.height * originalScale) * scale
        var height: CGFloat = .zero
        if contentScaleHeight > containerHeight {
            let heightLimit = (contentScaleHeight - containerHeight) / 2
            
            height = offset.height > 0 ?
                .minimum(heightLimit, offset.height) :
                .maximum(-heightLimit, offset.height)
        }
        
        return CGSize(width: width, height: height)
    }
    
    private func getOriginalScale(geometry: GeometryProxy) -> CGFloat {
        let containerSize = geometry.size
        let contentWidth = contentSize.width
        let contentHeight = contentSize.height
        let containerWidth = containerSize.width
        let containerHeight = containerSize.height
        
        let originalScale = contentWidth / contentHeight >= containerWidth / containerHeight ?
            containerWidth / contentWidth :
            containerHeight / contentHeight
        
        return originalScale
    }
}

typealias GotoPreviousPage = () -> Bool
typealias GotoNextPage = () -> Bool
typealias OnTapped = () -> Void

extension View {
    func onTapGestureIf(_ condition: Bool, closure: @escaping () -> Void) -> some View {
        self.allowsHitTesting(condition)
            .onTapGesture {
                closure()
            }
    }
}
