//
//  DragHandleView.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/19.
//

import SwiftUI

struct DragHandleView<Content>: View where Content: View {
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
                let offsetWidth = (model.width - Constants.minWidth) / 2
                print("offsetWidth width \(offsetWidth)")
                offset = CGSize(width: offsetWidth, height: 0)
                
//                var copyModel = model
//                copyModel.location = CGPoint(x: model.location.x + offsetWidth, y: model.location.y)
//                copyModel.width = max(Constants.minWidth, model.width + value.translation.width)
//                dataModel.updateAnnotations(annotation: copyModel)
            }.onEnded { _ in
                print("right drag and should update annotation width")
            }
    }
    
    var dragLeftGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                width = max(Constants.minWidth, width + value.translation.width * -1)
                let offsetWidth = (model.width - Constants.minWidth) / 2 * -1
                print("offsetWidth width \(offsetWidth)")
                offset = CGSize(width: offsetWidth, height: 0)
                
//                var copyModel = model
//                copyModel.location = CGPoint(x: model.location.x + offsetWidth, y: model.location.y)
//                copyModel.width = max(Constants.minWidth, model.width + value.translation.width * -1)
//                dataModel.updateAnnotations(annotation: copyModel)
            }.onEnded { _ in
                print("left drag and should update annotation width")
            }
    }
    
    @State private var dragOffset = CGSize.zero

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = CGSize(
                    width: value.startLocation.x + value.translation.width - model.width / 2,
                    height: value.startLocation.y + value.translation.height - model.height / 2
                )
            }
            .onEnded { _ in
                var copyModel = model
                let originalLocation = model.location
                copyModel.location = CGPoint(x: originalLocation.x + offset.width, y: originalLocation.y + offset.height)
                dataModel.updateAnnotations(annotation: copyModel)
                dragOffset = .zero
            }
    }
    
    var body: some View {
        if model.isSelected {
            ZStack(alignment: .center) {
                content()
//                    .frame(width: width, height: height)
//                    .border(.blue, width: model.isSelected ? 2 : 0)
//                    .background(model.backgroundColor)
//                    .offset(dragOffset)
//                    .gesture(dragGesture)
//                    .onTapGesture {
//                        dataModel.updateAnnotations(annotation: model, isNewSelected: true)
//                        dataModel.didTap(annotation: model)
//                    }
                VStack {
                    DragHandle()
                    Spacer()
                    DragHandle()
                }
            }
            .frame(width: width + Constants.handleSize, height: height + Constants.handleSize)
            .position(x: model.location.x + offset.width, y: model.location.y)
        } else {
            content()
                .position(model.location)
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
    static let handleSize: CGFloat = 30
}

struct DragHandleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
