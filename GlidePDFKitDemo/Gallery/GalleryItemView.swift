import SwiftUI

struct GalleryItemView: View {
    let width: Double
    let height: Double
    let item: Item

    @EnvironmentObject var dataModel: DataModel
    @State var image: Image?

    var body: some View {
        ZStack {
            if let img = image {
                img.resizable()
                    .scaledToFit()
                    .frame(width: width, height: height, alignment: .center)
            } else {
                ProgressView()
            }
        }.task {
            let img = await dataModel.fetchImage(index: item.index)
            Task { @MainActor in
                image = img
            }
        }
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
