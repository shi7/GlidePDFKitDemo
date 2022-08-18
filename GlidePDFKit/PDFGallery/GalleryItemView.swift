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
                    ZStack {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                        if let anotationArray = item.anotationArray {
                            ForEach(anotationArray) { item in
                                if item.type == .image {
                                    GlidePDFKitImageAnnotation(model: item).position(item.location)
                                } else {
                                    GlidePDFKitTextAnnotation(model: item).position(item.location)
                                }
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }.task {
            guard image == nil else {
                // MARK: Debug
                print("image already fetched, cancel refetch at page: \(item.pageNumber)")
                return
            }

            let img = dataModel.fetchImageAt(page: item.pageNumber)
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
