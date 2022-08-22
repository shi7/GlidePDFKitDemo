//
//  DragAndTapGestureWrapper.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/22.
//

import SwiftUI

struct DragAndTapGestureWrapper<Content>: View where Content: View {
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
        
        let onTap = {
            var copyModel = model
            copyModel.isSelected = !model.isSelected
            dataModel.updateAnnotations(annotation: copyModel, isNewSelected: true)
//            dataModel.didTap(annotation: model)
        }
        
        content()
            .modifier(DraggableModifier(pos: model.location, onDragEnd: onDragEnd))
            .onTapGesture { onTap() }
    }
}

struct DragAndTapGestureWrapper_Previews: PreviewProvider {
    static var previews: some View {
        Group{}
    }
}
