import SwiftUI

struct GlidePDFKitLineAnnotation: View {
    @EnvironmentObject var dataModel: ViewModel
    var model: GlidePDFKitAnnotationModel
    @State var scale: CGFloat = 0
    @State private var width: CGFloat = 0

    init(model: GlidePDFKitAnnotationModel, scale: CGFloat) {
        self.model = model
        self.scale = scale
        self.width = model.width
    }

    var body: some View {
        let onEnd: OnDrag = { size, pos in
            var copyModel = model
            copyModel.location = pos
            copyModel.width = size.width
            copyModel.height = size.height

            dataModel.updateAnnotations(annotation: copyModel)
        }

        let onDrag: OnDrag = { size, pos in
            width = size.width
        }

        if model.isSelected {
            DragAndTapGestureWrapper(model: model) {
                ResizableView(
                    pos: model.location,
                    width: model.width,
                    height: model.height,
                    backgroundColor: .clear,
                    onEnd: onEnd,
                    onDrag: onDrag,
                    verticalDisable: true
                ) {
                    VStack {
                        Rectangle()
                            .frame(width: width, height: 1, alignment: .center)
                            .background(Color.black)
                    }
                    .frame(width: width, height: model.height)
                    .contentShape(Rectangle())
                }
            }.zIndex(model.isSelected ? 1 : 0)
        } else {
            PDFAnnotation(model: model) {
                VStack {
                    Rectangle()
                        .frame(width: model.width, height: 1, alignment: .center)
                        .background(Color.black)
                }
                .frame(width: model.width, height: model.height)
                .contentShape(Rectangle())
            }
            .position(model.location)
            .zIndex(model.isSelected ? 1 : 0)
        }
    }
}

struct GlidePDFKitLineAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        let model = GlidePDFKitAnnotationModel(type: .line, location: CGPoint(x: 150, y: 210), width: 150, height: 40)
        return GlidePDFKitLineAnnotation(model: model, scale: 1)
            .environmentObject(ViewModel())
    }
}
