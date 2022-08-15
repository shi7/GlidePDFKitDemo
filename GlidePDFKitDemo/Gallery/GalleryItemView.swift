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
            guard image == nil else {
#if DEBUG
                print("image already fetched, cancel refetch at page: \(item.pageNumber)")
#endif
                return
            }
            
            let img = await dataModel.fetchImageAt(page: item.pageNumber)
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
