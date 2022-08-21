import SwiftUI

struct GlidePDFKitTextAnnotation: View {
    @EnvironmentObject var dataModel: ViewModel

    var model: GlidePDFKitAnnotationModel

    @State var scale: CGFloat
    var body: some View {
        if model.isSelected {
            HorizontalDraggableView(model: model) {
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
