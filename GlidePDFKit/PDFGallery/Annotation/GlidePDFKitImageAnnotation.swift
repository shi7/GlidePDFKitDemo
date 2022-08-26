import SwiftUI

struct GlidePDFKitImageAnnotation: View {
    var model: GlidePDFKitAnnotationModel
    @State var scale: CGFloat

    var body: some View {
        PDFAnnotation(model: model) {
            if let image = model.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Text("")
            }
        }
        .position(model.location)
    }
}
