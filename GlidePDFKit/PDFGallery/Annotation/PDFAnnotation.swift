//
//  PDFAnnotation.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/19.
//

import SwiftUI

struct PDFAnnotation<Content>: View where Content: View {
    @ViewBuilder private var content: () -> Content
    @EnvironmentObject var dataModel: ViewModel
    // TODO: Maybe we can move this property to viewModel, it passed so many times
    var model: GlidePDFKitAnnotationModel

    init(model: GlidePDFKitAnnotationModel, @ViewBuilder content: @escaping () -> Content) {
        self.model = model
        self.content = content
    }

    var body: some View {
        let onDragEnd: OnDragEnd = { pos in
            var copyModel = model
            copyModel.location = pos
            dataModel.updateAnnotations(annotation: copyModel)
        }
        
        content()
            .frame(width: model.width, height: model.height)
            .border(.blue, width: model.isSelected ? 2 : 0)
            .background(model.backgroundColor)
            .modifier(DraggableModifier(pos: model.location, onDragEnd: onDragEnd, model: model))
            .onTapGesture {
                dataModel.updateAnnotations(annotation: model, isNewSelected: true)
                dataModel.didTap(annotation: model)
            }
    }
}

struct PDFAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
