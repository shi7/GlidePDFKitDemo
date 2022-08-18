import SwiftUI

struct GlidePDFKitButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct GlidePDFKitTextAnnotation: View {
    @State var model: GlidePDFKitAnnotationModel
    @EnvironmentObject var dataModel: ViewModel

    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { self.model.location = $0.location }
            .onEnded { _ in }

        return Button(action: {
            model.isSelected.toggle()
            dataModel.updateAnotations(anotation: model,isNewSelected: model.isSelected)
        }) {
            Text(model.text)
                    .frame(width: model.width, height: model.height)
                    .border(.blue, width: model.isSelected ? 2 : 0)
                    .foregroundColor(.primary)
        }
        .background(model.backgroundColor)
        .position(model.location)
        .highPriorityGesture(dragGesture)
        .buttonStyle(GlidePDFKitButtonStyle())
    }
}
