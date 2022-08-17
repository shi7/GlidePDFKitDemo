import SwiftUI

struct GlidePDFKitTextAnnotation: View {
    @State var model: GlidePDFKitAnnotationModel
    @EnvironmentObject var dataModel: ViewModel

    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { self.model.location = $0.location }
            .onEnded { _ in }

        return Button(action: {
            model.isSelected.toggle()
            dataModel.updateAnotations(anotation: model)
        }) {
            Text(model.text)
                .frame(width: model.width, height: model.height)
                .border(.orange, width: model.isSelected ? 1 : 0)
                .foregroundColor(.primary)
        }
        .position(model.location)
        .highPriorityGesture(dragGesture)
    }
}
