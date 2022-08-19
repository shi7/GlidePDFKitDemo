import SwiftUI

struct GlidePDFKitTextAnnotation: View {
    var model: GlidePDFKitAnnotationModel
    @State var scale: CGFloat

    var body: some View {
        PDFAnnotation(model: model) {
            Text(model.text)
        }
    }
}
