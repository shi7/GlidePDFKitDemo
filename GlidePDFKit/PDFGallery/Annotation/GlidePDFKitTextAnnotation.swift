import SwiftUI

struct GlidePDFKitTextAnnotation: View {
    var model: GlidePDFKitAnnotationModel
    @State var scale: CGFloat
    @State private var sizeOffset = CGSize.zero
    @EnvironmentObject var dataModel: ViewModel

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                sizeOffset = value.translation
            }
            .onEnded { _ in
                var copyModel = model
                copyModel.width = copyModel.width + sizeOffset.width
                copyModel.height = copyModel.height + sizeOffset.height
                dataModel.updateAnnotations(annotation: copyModel)
                sizeOffset = .zero
            }
    }

    var body: some View {
        PDFAnnotation(model: model) {
            HStack {
                Text(model.text)
                Text("ZoomDragTest")
                    .highPriorityGesture(dragGesture)
            }
        }
    }
}
