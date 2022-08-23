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
    
    init(
        size: CGSize,
        gotoPreviousPage: @escaping GotoPreviousPage,
        gotoNextPage: @escaping GotoNextPage
    ) {
        contentSize = size
        self.gotoPreviousPage = gotoPreviousPage
        self.gotoNextPage = gotoNextPage
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            let magnificationGesture = MagnificationGesture()
                .onChanged { gesture in
                    scale = lastScale * gesture
                }
                .onEnded { _ in
                    fixScale(geometry: geometry, content: content)
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
                    if offset.height > turnPageThreshold {
                        print("need scroll to previous page")
                        gotoPreviousPage()
                        return
                    } else if offset.height < turnPageThreshold * -1 {
                        print("need scroll to next page")
                        gotoNextPage()
                        return
                    }
                    
                    let velocity = CGSize(
                        width: value.predictedEndLocation.x - value.location.x,
                        height: value.predictedEndLocation.y - value.location.y
                    )
                    
                    // MARK: Debug
                    
                    print("velocity height \(velocity.height)")
                    
                    if velocity.height > Constants.scrollDistance {
                        gotoPreviousPage()
                    } else if velocity.height < -Constants.scrollDistance {
                        gotoNextPage()
                    } else {
                        fixOffset(geometry: geometry, content: content)
                    }
                }
            
            content
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .scaleEffect(scale, anchor: .center)
                .offset(offset)
                .gesture(TapGesture(count: 1), including: isScaled ? .none : .all)
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
        static let scrollDistance: CGFloat = 6000
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
    
    private func fixScale(geometry _: GeometryProxy, content _: Content) {
        let newScale: CGFloat = .minimum(.maximum(scale, Constants.minScale), Constants.maxScale)
        lastScale = newScale
        withAnimation {
            scale = newScale
        }
    }
    
    private func fixOffset(geometry: GeometryProxy, content _: Content) {
        let containerSize = geometry.size
        let containerWidth = containerSize.width
        let containerHeight = containerSize.height
        
        let originalScale = getOriginalScale(geometry: geometry)
        let contentScaleWidth = (contentSize.width * originalScale) * scale
        
        print("originalScale \(originalScale)")
        var width: CGFloat = .zero
        if contentScaleWidth > containerWidth {
            let widthLimit: CGFloat = contentScaleWidth > containerWidth ?
            (contentScaleWidth - containerWidth) / 2
            : 0
            
            width = offset.width > 0 ?
                .minimum(widthLimit, offset.width) :
                .maximum(-widthLimit, offset.width)
        }
        
        let contentScaleHeight = (contentSize.height * originalScale) * scale
        var height: CGFloat = .zero
        if contentScaleHeight > containerHeight {
            let heightLimit: CGFloat = contentScaleHeight > containerHeight ?
            (contentScaleHeight - containerHeight) / 2 :
            0
            
            print("height limit \(heightLimit)")
            height = offset.height > 0 ?
                .minimum(heightLimit, offset.height) :
                .maximum(-heightLimit, offset.height)
        }
        
        let newOffset = CGSize(width: width, height: height)
        lastOffset = newOffset
        withAnimation {
            offset = newOffset
        }
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

typealias GotoPreviousPage = () -> Void
typealias GotoNextPage = () -> Void

extension View {
    func onTapGestureIf(_ condition: Bool, closure: @escaping () -> Void) -> some View {
        self.allowsHitTesting(condition)
            .onTapGesture {
                closure()
            }
    }
}
