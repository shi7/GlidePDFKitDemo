import SwiftUI

struct GalleryItemView: View {
    let width: Double
    let height: Double
    let item: GalleryItem

    @EnvironmentObject var dataModel: ViewModel
    @State var image: UIImage?

    var body: some View {
        ZStack {
            if let img = image {
                MagnificationView(size: img.size) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                }
            } else {
                ProgressView()
            }
            if let anotationArray = item.anotationArray {
                ForEach(anotationArray) { item in
                    ImageAnotationView(model: item).position(CGPoint(x: item.x, y: item.y))
                }
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
        .frame(width: width, height: height, alignment: .center)
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
