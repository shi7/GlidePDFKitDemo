import SwiftUI

struct GlidePDFKitImageAnnotation: View {

    @State var model: GlidePDFKitAnotationModel
    @EnvironmentObject var dataModel: ViewModel

    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { self.model.location = $0.location }
            .onEnded { value in }

        return Button(action: {
            model.isSelected.toggle()
            dataModel.updateAnotations(anotations: model)
        }) {
            if let image = model.image {
                Image(uiImage: image)
                    .border(.orange,width: model.isSelected ? 1 : 0)
            }
        }
        .frame(width: 200, height: 100)
        .position(model.location)
        .highPriorityGesture(dragGesture)
    }
}
