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
        DragAndTapGestureWrapper(model: model) {
            HStack(spacing: 0) {
                PDFMultiPartText("1")

                content()
                    .frame(width: model.width, height: model.height)
                    .background(model.type == .line ? Color.clear : model.backgroundColor)
                    .modifier(
                        PDFKitBorderModifier(
                            model.isCircle,
                            showBorder: model.isSelected
                        )
                    )
            }
        }
    }
}

struct PDFAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
