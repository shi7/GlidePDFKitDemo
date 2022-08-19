import SwiftUI

struct GlidePDFKitTextAnnotation: View {
    @EnvironmentObject var dataModel: ViewModel
    
    var model: GlidePDFKitAnnotationModel
    
    @State var scale: CGFloat
    var body: some View {
        DragHandleView(model: model) {
            PDFAnnotation(model: model) {
                Text(model.text)
            }
        }
    }
}
