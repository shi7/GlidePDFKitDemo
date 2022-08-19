//
//  PDFAnnotation.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/19.
//

import SwiftUI

struct PDFAnnotation<Content>: View where Content: View {
    @ViewBuilder private var content: () -> Content

    @State private var offset = CGSize.zero
    @State var sizeOffset = CGSize.zero
    var model: GlidePDFKitAnnotationModel
    @EnvironmentObject var dataModel: ViewModel

    init(model: GlidePDFKitAnnotationModel, @ViewBuilder content: @escaping () -> Content) {
        self.model = model
        self.content = content
    }

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = CGSize(
                    width: value.startLocation.x + value.translation.width - model.width / 2,
                    height: value.startLocation.y + value.translation.height - model.height / 2
                )
            }
            .onEnded { _ in
                var copyModel = model
                let originalLocation = model.location
                copyModel.location = CGPoint(x: originalLocation.x + offset.width, y: originalLocation.y + offset.height)
                dataModel.updateAnnotations(annotation: copyModel)
                offset = .zero
            }
    }

    var body: some View {
        content()
            // TODO: need keep width/height greater than 0 after calculation
            .frame(width: model.width + sizeOffset.width, height: model.height + sizeOffset.height)
            .border(.blue, width: model.isSelected ? 2 : 0)
            .background(model.backgroundColor)
            .offset(offset)
            .gesture(dragGesture)
            .onTapGesture {
                dataModel.updateAnnotations(annotation: model, isNewSelected: true)
                dataModel.didTap(annotation: model)

                // MARK: Debug

                print("capture tap gesture -- ")
            }
            .position(model.location)
    }
}

struct PDFAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
