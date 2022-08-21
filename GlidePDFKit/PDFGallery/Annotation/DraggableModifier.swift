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

    // TODO: remove the business logic to topper view, maybe pass a callback closure
    @EnvironmentObject var dataModel: ViewModel
    var model: GlidePDFKitAnnotationModel

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

    public func body(content: Content) -> some View {
        content
            .offset(offset)
            .gesture(dragGesture)
            .onTapGesture {
                dataModel.updateAnnotations(annotation: model, isNewSelected: true)
                dataModel.didTap(annotation: model)
            }
    }
}
