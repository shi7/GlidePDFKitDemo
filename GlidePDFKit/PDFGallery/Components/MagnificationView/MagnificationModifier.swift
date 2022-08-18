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
    @State var debug = ""
    @EnvironmentObject var dataModel: ViewModel

    private var contentSize: CGSize
    
    init(size: CGSize) {
        contentSize = size
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
                    if scale - 1 > Constants.scalePrecision {
                        newOffset.width += gesture.translation.width
                    }
                    newOffset.height += gesture.translation.height
                    offset = newOffset
                }
                .onEnded { value in
                    let velocity = CGSize(
                        width: value.predictedEndLocation.x - value.location.x,
                        height: value.predictedEndLocation.y - value.location.y
                    )
                    // MARK: Debug
                    print("velocity height \(velocity.height)")
                    
                    if velocity.height > Constants.scrollDistance {
                        withAnimation {
                            dataModel.activePage -= 1
                        }
                    }else if velocity.height < -Constants.scrollDistance {
                        withAnimation {
                            dataModel.activePage += 1
                        }
                    }else {
                        fixOffset(geometry: geometry, content: content)
                    }
                    
                    // MARK: Debug
                    print("active page \(dataModel.activePage)")
                }

            content
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .scaleEffect(scale, anchor: .center)
                .offset(offset)
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
        static let scalePrecision: CGFloat =  0.001
        static let minScale: CGFloat = 1
        static let maxScale: CGFloat = 4
    }
    
    private func reset() {
        scale = 1
        lastScale = 1
        offset = .zero
        lastOffset = .zero
    }

    private func fixScale(geometry: GeometryProxy, content _: Content) {
        let newScale: CGFloat = .minimum(.maximum(scale, Constants.minScale), Constants.maxScale)
        lastScale = newScale
        withAnimation {
            scale = newScale
        }
    }
    
    private func fixOffset(geometry: GeometryProxy, content _: Content) {
        let containerSize = geometry.size
        let contentWidth = contentSize.width
        let contentHeight = contentSize.height
        let containerWidth = containerSize.width
        let containerHeight = containerSize.height

        let originalScale = contentWidth / contentHeight >= containerWidth / containerHeight ?
            containerWidth / contentWidth :
            containerHeight / contentHeight

        let contentScaleWidth = (contentWidth * originalScale) * scale

        var width: CGFloat = .zero
        if contentScaleWidth > containerWidth {
            let widthLimit: CGFloat = contentScaleWidth > containerWidth ?
                (contentScaleWidth - containerWidth) / 2
                : 0

            width = offset.width > 0 ?
                .minimum(widthLimit, offset.width) :
                .maximum(-widthLimit, offset.width)
        }

        let contentScaleHeight = (contentHeight * originalScale) * scale
        var height: CGFloat = .zero
        if contentScaleHeight > containerHeight {
            let heightLimit: CGFloat = contentScaleHeight > containerHeight ?
                (contentScaleHeight - containerHeight) / 2 :
                0

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
}