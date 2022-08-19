//
//  HorizontalDraggableView.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/19.
//

import SwiftUI

struct HorizontalDraggableView<Content>: View where Content: View {
    @State private var width: CGFloat = Constants.minWidth
    @State private var height: CGFloat = Constants.minHeight
    @State var offset: CGSize = .zero
    @ViewBuilder let content: () -> Content
    @EnvironmentObject var dataModel: ViewModel
    
    var model: GlidePDFKitAnnotationModel
    
    init(model: GlidePDFKitAnnotationModel, content: @escaping () -> Content) {
        self.model = model
        self.content = content
        self.width = model.width
        self.height = model.height
    }
    
    var dragRightGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                width = max(Constants.minWidth, width + value.translation.width)
                let offsetWidth = (width - model.width) / 2
                offset = CGSize(width: offsetWidth, height: 0)
                print("offsetWidth width \(offsetWidth)")
            }.onEnded { _ in
                
                // MARK: Debug
                
                print("right drag and should update annotation width")
                var copyModel = model
                copyModel.location = CGPoint(x: model.location.x + offset.width, y: model.location.y)
                copyModel.width = width
                
                dataModel.updateAnnotations(annotation: copyModel)
                offset = .zero
            }
    }
    
    var dragLeftGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                width = max(Constants.minWidth, width + value.translation.width * -1)
                let offsetWidth = (width - model.width) / 2 * -1
                offset = CGSize(width: offsetWidth, height: 0)
                
                // MARK: Debug
                
                print("offsetWidth width \(offsetWidth)")
            }.onEnded { _ in
                
                // MARK: Debug
                
                print("left drag and should update annotation width")
                var copyModel = model
                copyModel.location = CGPoint(x: model.location.x + offset.width, y: model.location.y)
                copyModel.width = width
                
                dataModel.updateAnnotations(annotation: copyModel)
                offset = .zero
            }
    }
    
    @State private var dragOffset = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = CGSize(
                    width: value.startLocation.x + value.translation.width - (width + Constants.handleSize) / 2,
                    height: value.startLocation.y + value.translation.height - (height + Constants.handleSize) / 2
                )
            }
            .onEnded { _ in
                var copyModel = model
                let originalLocation = model.location
                copyModel.location = CGPoint(x: originalLocation.x + dragOffset.width, y: originalLocation.y + dragOffset.height)
                dataModel.updateAnnotations(annotation: copyModel)
                dragOffset = .zero
            }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                content()
                    .frame(width: width, height: height)
                    .border(.blue, width: model.isSelected ? 2 : 0)
                    .background(model.backgroundColor)
                VStack {
                    DragHandle()
                    Spacer()
                    DragHandle()
                }
            }
            .frame(width: width + Constants.handleSize, height: height + Constants.handleSize)
            .offset(dragOffset)
            .gesture(dragGesture)
            .onTapGesture {
                dataModel.updateAnnotations(annotation: model, isNewSelected: true)
                dataModel.didTap(annotation: model)
            }
            .position(x: model.location.x + offset.width, y: model.location.y)
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

private enum Constants {
    static let minWidth: CGFloat = 100
    static let minHeight: CGFloat = 40
    static let handleSize: CGFloat = 15
}

struct HorizontalDraggableView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
