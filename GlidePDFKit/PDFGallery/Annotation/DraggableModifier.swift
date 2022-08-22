//
//  DraggableModifier.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/20.
//

import Foundation
import SwiftUI

public struct DraggableModifier: ViewModifier {
    @State private var offset = CGSize.zero
    
    var position: CGPoint
    var onDragEnd: OnDragEnd
    
    init(pos: CGPoint, onDragEnd: @escaping OnDragEnd) {
        self.position = pos
        self.onDragEnd = onDragEnd
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(offset)
            .gesture(dragGesture)
    }
}

extension DraggableModifier {
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = CGSize(width: value.translation.width, height: value.translation.height)
            }
            .onEnded { _ in
                onDragEnd(CGPoint(x: position.x + offset.width, y: position.y + offset.height))
                offset = .zero
            }
    }
}

typealias OnDragEnd = (CGPoint) -> Void
