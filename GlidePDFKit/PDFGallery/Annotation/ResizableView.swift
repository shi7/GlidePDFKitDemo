//
//  HorizontalDraggableView.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/19.
//

import SwiftUI

struct ResizableView<Content>: View where Content: View {
    @State private var width: CGFloat = .zero
    @State private var height: CGFloat = .zero
    @State var offset: CGSize = .zero
    
    @State private var lastWidth: CGFloat = Constants.minWidth
    @State private var lastHeight: CGFloat = Constants.minHeight
    @State var lastPos: CGPoint = .zero
    
    @ViewBuilder let content: () -> Content
    
    let onEnd: OnEnd
    let position: CGPoint
    let size: CGSize
    
    var model: GlidePDFKitAnnotationModel

    init(model: GlidePDFKitAnnotationModel, pos: CGPoint, size: CGSize, onEnd: @escaping OnEnd, content: @escaping () -> Content) {
        self.model = model
        self.position = pos
        self.size = size
        self.onEnd = onEnd
        self.content = content
    }

    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                content()
                    .frame(width: width, height: height)
                    .border(.blue, width: model.isSelected ? 2 : 0)
                    .background(model.backgroundColor)
                VStack {
                    TopLineDragHandle()
                    Spacer()
                    BottomLineDragHandle()
                }
            }
            .frame(width: width + Constants.handleSize, height: height + Constants.handleSize)
            .modifier(DraggableModifier(model: model))
            .position(x: lastPos.x + offset.width, y: lastPos.y + offset.height)
        }
        .onAppear {
            width = size.width
            height = size.height
            lastPos = position
        }
    }

    private func TopLineDragHandle() -> some View {
        HStack {
            DragCircle().gesture(dragLeftTopGesture)
            Spacer()
            DragCircle().gesture(dragTopGesture)
            Spacer()
            DragCircle().gesture(dragRightTopGesture)
        }
    }
    
    private func BottomLineDragHandle() -> some View {
        HStack {
            DragCircle().gesture(dragLeftBottomGesture)
            Spacer()
            DragCircle().gesture(dragBottomGesture)
            Spacer()
            DragCircle().gesture(dragRightBottomGesture)
        }
    }
    
    private func DragHandle() -> some View {
        HStack {
            DragCircle().gesture(dragLeftGesture)
            Spacer()
            DragCircle().gesture(dragRightGesture)
        }
    }

    private func DragCircle() -> some View {
        Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(Circle().foregroundColor(.white))
            .frame(width: Constants.handleSize, height: Constants.handleSize)
    }
}

extension ResizableView {
    // TODO: extract the horizontal drag zoom gesture to ViewModifier
    var dragRightGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let rightTuple = rightWidthAndOffsetOf(value)
                width = rightTuple.width
                offset = CGSize(width: rightTuple.offset, height: offset.height)
            }.onEnded { _ in
                updateState()
            }
    }
    
    var dragLeftGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let leftTuple = leftWidthAndOffsetOf(value)
                width = leftTuple.width
                offset = CGSize(width: leftTuple.offset, height: offset.height)
            }.onEnded { _ in
                updateState()
            }
    }
    
    var dragTopGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let topTuple = topHeightAndOffsetOf(value)
                height = topTuple.height
                offset = CGSize(width: offset.width, height: topTuple.offset)
            }.onEnded { _ in
                updateState()
            }
    }
    
    var dragBottomGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let bottomTuple = bottomHeightAndOffsetOf(value)
                height = bottomTuple.height
                offset = CGSize(width: offset.width, height: bottomTuple.offset)
            }.onEnded { _ in
                updateState()
            }
    }
    
    var dragLeftTopGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let leftTuple = leftWidthAndOffsetOf(value)
                let topTuple = topHeightAndOffsetOf(value)
                width = leftTuple.width
                height = topTuple.height
                offset = CGSize(width: leftTuple.offset, height: topTuple.offset)
            }.onEnded { _ in
                updateState()
            }
    }
    
    var dragRightTopGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let rightTuple = rightWidthAndOffsetOf(value)
                let topTuple = topHeightAndOffsetOf(value)
                width = rightTuple.width
                height = topTuple.height
                offset = CGSize(width: rightTuple.offset, height: topTuple.offset)
            }.onEnded { _ in
                updateState()
            }
    }
    
    var dragLeftBottomGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let leftTuple = leftWidthAndOffsetOf(value)
                let bottomTuple = bottomHeightAndOffsetOf(value)
                width = leftTuple.width
                height = bottomTuple.height
                offset = CGSize(width: leftTuple.offset, height: bottomTuple.offset)
            }.onEnded { _ in
                updateState()
            }
    }
    
    var dragRightBottomGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let rightTuple = rightWidthAndOffsetOf(value)
                let bottomTuple = bottomHeightAndOffsetOf(value)
                width = rightTuple.width
                height = bottomTuple.height
                offset = CGSize(width: rightTuple.offset, height: bottomTuple.offset)
            }.onEnded { _ in
                updateState()
            }
    }
    
    private func updateState() {
        self.onEnd(CGSize(width: width, height: height), CGPoint(x: lastPos.x + offset.width, y: lastPos.y + offset.height))
        
        lastWidth = width
        lastHeight = height
        lastPos = CGPoint(x: lastPos.x + offset.width, y: lastPos.y + offset.height)
        
        offset = .zero
    }
    
    private func rightWidthAndOffsetOf(_ value: DragGesture.Value) -> (width: CGFloat, offset: CGFloat) {
        let width = max(Constants.minWidth, width + value.translation.width)
        let offsetWidth = (width - lastWidth) / 2
        print("right width \(width) offsetWidth \(offsetWidth)")
        
        return (width, offsetWidth)
    }
    
    private func leftWidthAndOffsetOf(_ value: DragGesture.Value) -> (width: CGFloat, offset: CGFloat) {
        let width = max(Constants.minWidth, width + value.translation.width * -1)
        let offsetWidth = (width - lastWidth) / 2 * -1
        print("left width \(width) offsetWidth \(offsetWidth)")
        
        return (width, offsetWidth)
    }
    
    private func topHeightAndOffsetOf(_ value: DragGesture.Value) -> (height: CGFloat, offset: CGFloat) {
        let height = max(Constants.minHeight, height + value.translation.height * -1)
        let offsetHeight = (height - lastHeight) / 2 * -1
        print("top height  \(height) offsetHeight \(offsetHeight)")
        
        return (height, offsetHeight)
    }
    
    private func bottomHeightAndOffsetOf(_ value: DragGesture.Value) -> (height: CGFloat, offset: CGFloat) {
        let height = max(Constants.minHeight, height + value.translation.height)
        let offsetHeight = (height - lastHeight) / 2
        print("bottom height \(height) offsetHeight \(offsetHeight)")
        
        return (height, offsetHeight)
    }
}

typealias OnEnd = (CGSize, CGPoint) -> Void

private enum Constants {
    static let minWidth: CGFloat = 100
    static let minHeight: CGFloat = 40
    static let maxWidth: CGFloat = 260
    static let maxHeight: CGFloat = 260
    static let handleSize: CGFloat = 15
}

struct ResizableView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
