//
//  MagnificationModifier.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/16.
//

import SwiftUI

public struct MagnificationModifier: ViewModifier {
    @State var scale: CGFloat = 1
    @State var scaleAnchor: UnitPoint = .center
    @State var lastScale: CGFloat = 1
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    @State var debug = ""
    
    private var contentSize: CGSize
    
    init(size: CGSize) {
        self.contentSize = size
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            let magnificationGesture = MagnificationGesture()
                .onChanged { gesture in
                    scaleAnchor = .center
                    scale = lastScale * gesture
                }
                .onEnded { _ in
                    fixOffsetAndScale(geometry: geometry, content: content)
                }
            
            let dragGesture = DragGesture()
                .onChanged { gesture in
                    var newOffset = lastOffset
                    newOffset.width += gesture.translation.width
                    newOffset.height += gesture.translation.height
                    offset = newOffset
                }
                .onEnded { _ in
                    fixOffsetAndScale(geometry: geometry, content: content)
                }
            
            content
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .scaleEffect(scale, anchor: scaleAnchor)
                .offset(offset)
                .onTapGesture {}
                .gesture(ExclusiveGesture(dragGesture, magnificationGesture))
                .onAppear {
                    reset()
                }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func reset() {
        scale = 1
        lastScale = 1
        offset = .zero
        lastOffset = .zero
    }
    
    private func fixOffsetAndScale(geometry: GeometryProxy, content: Content) {
        let newScale: CGFloat = .minimum(.maximum(scale, 1), 4)
        let screenSize = geometry.size
        
        let contentWidth = contentSize.width
        let contentHeight = contentSize.height
        let containerWidth = geometry.size.width
        let containerHeight = geometry.size.height
        
        let originalScale = contentWidth / contentHeight >= containerWidth / containerHeight ?
        containerWidth / contentWidth :
        containerHeight / contentHeight
        
        let contentScaleWidth = (contentWidth * originalScale) * newScale
        
        var width: CGFloat = .zero
        if contentScaleWidth > containerWidth {
            let widthLimit: CGFloat = contentScaleWidth > screenSize.width ?
            (contentScaleWidth - containerWidth) / 2
            : 0
            
            width = offset.width > 0 ?
                .minimum(widthLimit, offset.width) :
                .maximum(-widthLimit, offset.width)
        }
        
        let contentScaleHeight = (contentHeight * originalScale) * newScale
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
        lastScale = newScale
        lastOffset = newOffset
        withAnimation {
            offset = newOffset
            scale = newScale
        }
    }
}
