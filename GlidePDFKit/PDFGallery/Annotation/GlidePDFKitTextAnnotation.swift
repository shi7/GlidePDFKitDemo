import SwiftUI

struct GlidePDFKitTextAnnotation: View {
    @EnvironmentObject var dataModel: ViewModel
    var model: GlidePDFKitAnnotationModel
    @State var scale: CGFloat

    var body: some View {
        let onEnd: OnEnd = { size, pos in
            var copyModel = model
            copyModel.location = pos
            copyModel.width = size.width
            copyModel.height = size.height
            
            dataModel.updateAnnotations(annotation: copyModel)
        }
        
        let onDragEnd: OnDragEnd = { pos in
            var copyModel = model
            copyModel.location = pos
            dataModel.updateAnnotations(annotation: copyModel)
        }
        
        if model.isSelected {
            ResizableView(model: model, pos: model.location, width: model.width, height: model.height, onEnd: onEnd) {
                Text(model.text)
            }
            .modifier(DraggableModifier(pos: model.location, onDragEnd: onDragEnd, model: model))
            .onTapGesture {
                dataModel.updateAnnotations(annotation: model, isNewSelected: true)
                dataModel.didTap(annotation: model)
            }
        } else {
            PDFAnnotation(model: model) {
                Text(model.text)
            }
            .position(model.location)
        }
    }
}

extension GlidePDFKitTextAnnotation {
}
