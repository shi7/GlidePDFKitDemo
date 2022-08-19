import SwiftUI

struct GlidePDFKitImageAnnotation: View {
    var model: GlidePDFKitAnnotationModel
    @State var scale: CGFloat

    var body: some View {
        PDFAnnotation(model: model) {
            if let image = model.image {
                Image(uiImage: image)
            } else {
                Text("Load Image error")
            }
        }
        .position(model.location)
    }
}
