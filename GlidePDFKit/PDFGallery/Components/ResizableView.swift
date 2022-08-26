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

    @ViewBuilder let content: () -> Content

    private var originalWidth: CGFloat
    private var originalHeight: CGFloat
    var position: CGPoint
    var backgroundColor: Color
    let onEnd: OnDrag
    let onDrag: OnDrag?
    let shapeCircle: Bool
    let verticalDisable: Bool

    init(
        pos: CGPoint,
        width: CGFloat,
        height: CGFloat,
        backgroundColor: Color,
        onEnd: @escaping OnDrag,
        onDrag: OnDrag? = nil,
        shapeCircle: Bool = false,
        verticalDisable: Bool = false,
        content: @escaping () -> Content
    ) {
        self.position = pos
        self.originalWidth = width
        self.originalHeight = height
        self.backgroundColor = backgroundColor
        self.onEnd = onEnd
        self.onDrag = onDrag
        self.shapeCircle = shapeCircle
        self.verticalDisable = verticalDisable
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .center) {
            content()
                .frame(width: width, height: height)
                .modifier(PDFKitBorderModifier(shapeCircle, showBorder: true))
                .background(backgroundColor)

            VStack {
                TopLineDragHandle()
                Spacer()
                BottomLineDragHandle()
            }
        }
        .frame(width: width + Constants.handleSize, height: height + Constants.handleSize)
        .position(x: position.x + offset.width, y: position.y + offset.height)
        .onAppear {
            width = originalWidth
            height = originalHeight
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
    var dragRightGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let rightTuple = rightWidthAndOffsetOf(value)
//                width = rightTuple.width
//                offset = CGSize(width: rightTuple.offset, height: offset.height)

                applyOritensionEnable(
                    newWidth: rightTuple.width,
                    newHeight: height,
                    newOffset: CGSize(width: rightTuple.offset, height: offset.height)
                )
                updateState(false)
            }.onEnded { _ in
                updateState()
            }
    }

    var dragLeftGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let leftTuple = leftWidthAndOffsetOf(value)
//                width = leftTuple.width
//                offset = CGSize(width: leftTuple.offset, height: offset.height)

                applyOritensionEnable(
                    newWidth: leftTuple.width,
                    newHeight: height,
                    newOffset: CGSize(width: leftTuple.offset, height: offset.height)
                )
                updateState(false)
            }.onEnded { _ in
                updateState()
            }
    }

    var dragTopGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let topTuple = topHeightAndOffsetOf(value)
//                height = topTuple.height
//                offset = CGSize(width: offset.width, height: topTuple.offset)

                applyOritensionEnable(
                    newWidth: width,
                    newHeight: topTuple.height,
                    newOffset: CGSize(width: offset.width, height: topTuple.offset)
                )
                updateState(false)
            }.onEnded { _ in
                updateState()
            }
    }

    var dragBottomGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let bottomTuple = bottomHeightAndOffsetOf(value)
//                height = bottomTuple.height
//                offset = CGSize(width: offset.width, height: bottomTuple.offset)

                applyOritensionEnable(
                    newWidth: width,
                    newHeight: bottomTuple.height,
                    newOffset: CGSize(width: offset.width, height: bottomTuple.offset)
                )
                updateState(false)
            }.onEnded { _ in
                updateState()
            }
    }

    var dragLeftTopGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let leftTuple = leftWidthAndOffsetOf(value)
                let topTuple = topHeightAndOffsetOf(value)
//                width = leftTuple.width
//                height = topTuple.height
//                offset = CGSize(width: leftTuple.offset, height: topTuple.offset)
                applyOritensionEnable(
                    newWidth: leftTuple.width,
                    newHeight: topTuple.height,
                    newOffset: CGSize(width: leftTuple.offset, height: topTuple.offset)
                )
                updateState(false)
            }.onEnded { _ in
                updateState()
            }
    }

    var dragRightTopGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let rightTuple = rightWidthAndOffsetOf(value)
                let topTuple = topHeightAndOffsetOf(value)
//                width = rightTuple.width
//                height = topTuple.height
//                offset = CGSize(width: rightTuple.offset, height: topTuple.offset)
                applyOritensionEnable(
                    newWidth: rightTuple.width,
                    newHeight: topTuple.height,
                    newOffset: CGSize(width: rightTuple.offset, height: topTuple.offset)
                )
                updateState(false)
            }.onEnded { _ in
                updateState()
            }
    }

    var dragLeftBottomGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let leftTuple = leftWidthAndOffsetOf(value)
                let bottomTuple = bottomHeightAndOffsetOf(value)
//                width = leftTuple.width
//                height = bottomTuple.height
//                offset = CGSize(width: leftTuple.offset, height: bottomTuple.offset)

                applyOritensionEnable(
                    newWidth: leftTuple.width,
                    newHeight: bottomTuple.height,
                    newOffset: CGSize(width: leftTuple.offset, height: bottomTuple.offset)
                )
                updateState(false)
            }.onEnded { _ in
                updateState()
            }
    }

    var dragRightBottomGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let rightTuple = rightWidthAndOffsetOf(value)
                let bottomTuple = bottomHeightAndOffsetOf(value)
//                width = rightTuple.width
//                height = bottomTuple.height
//                offset = CGSize(width: rightTuple.offset, height: bottomTuple.offset)

                applyOritensionEnable(
                    newWidth: rightTuple.width,
                    newHeight: bottomTuple.height,
                    newOffset: CGSize(width: rightTuple.offset, height: bottomTuple.offset)
                )
                updateState(false)
            }.onEnded { _ in
                updateState()
            }
    }

    private func applyOritensionEnable(newWidth: CGFloat, newHeight: CGFloat, newOffset: CGSize) {
        width = newWidth

        if verticalDisable {
            offset = CGSize(width: newOffset.width, height: 0)
        } else {
            offset = CGSize(width: newOffset.width, height: newOffset.height)
            height = newHeight
        }
    }

    private func updateState(_ onEnd: Bool = true) {
        let size = CGSize(width: width, height: height)
        let point = CGPoint(x: position.x + offset.width, y: position.y + offset.height)
        if onEnd {
            self.onEnd(size, point)
            offset = .zero
        } else {
            self.onDrag?(size, point)
        }
    }

    private func rightWidthAndOffsetOf(_ value: DragGesture.Value) -> (width: CGFloat, offset: CGFloat) {
        let width = max(Constants.minWidth, width + value.translation.width)
        let offsetWidth = (width - originalWidth) / 2
        print("right width \(width) offsetWidth \(offsetWidth)")

        return (width, offsetWidth)
    }

    private func leftWidthAndOffsetOf(_ value: DragGesture.Value) -> (width: CGFloat, offset: CGFloat) {
        let width = max(Constants.minWidth, width + value.translation.width * -1)
        let offsetWidth = (width - originalWidth) / 2 * -1
        print("left width \(width) offsetWidth \(offsetWidth)")

        return (width, offsetWidth)
    }

    private func topHeightAndOffsetOf(_ value: DragGesture.Value) -> (height: CGFloat, offset: CGFloat) {
        let height = max(Constants.minHeight, height + value.translation.height * -1)
        let offsetHeight = (height - originalHeight) / 2 * -1
        print("top height  \(height) offsetHeight \(offsetHeight)")

        return (height, offsetHeight)
    }

    private func bottomHeightAndOffsetOf(_ value: DragGesture.Value) -> (height: CGFloat, offset: CGFloat) {
        let height = max(Constants.minHeight, height + value.translation.height)
        let offsetHeight = (height - originalHeight) / 2
        print("bottom height \(height) offsetHeight \(offsetHeight)")

        return (height, offsetHeight)
    }
}

typealias OnDrag = (CGSize, CGPoint) -> Void

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
