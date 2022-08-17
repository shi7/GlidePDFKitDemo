import SwiftUI

struct GalleryItemView: View {
    let width: Double
    let height: Double
    let item: GalleryItem
    
    @EnvironmentObject var dataModel: ViewModel
    @State var image: UIImage?
    
    var body: some View {
        Group {
            if let img = image {
                MagnificationView(size: img.size) {
                    ZStack {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                        
                        PDFTextAnnotation(
                            position: item.position,
                            size: item.size,
                            pageNum: item.pageNumber
                        )
                    }.frame(width: img.size.width, height: img.size.height, alignment: .center)
                }
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
        .frame(width: width, height: height, alignment: .center)
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
