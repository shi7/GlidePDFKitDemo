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
        
        if model.isSelected {
            ResizableView(model: model, pos: model.location, width: model.width, height: model.height, onEnd: onEnd) {
                Text(model.text)
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
