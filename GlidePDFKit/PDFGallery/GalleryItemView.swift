import SwiftUI

struct GalleryItemView: View {
    let width: Double
    let height: Double
    let item: GalleryItem

    @EnvironmentObject var dataModel: ViewModel
    @State var image: UIImage?

    func resetScale() -> Void {
        if let img = image {
            let scaleW = width / img.size.width
            let scaleH = height / img.size.height
            let trueScale =  min( scaleW , scaleH)
            item.scale = trueScale
        }
    }

    var body: some View {
        ZStack {
            if let img = image {
                MagnificationView(size: img.size) {
                    ZStack {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                        if let annotationArray = item.annotationsArray {
                            ForEach(annotationArray) { annotation in
                                if annotation.type == .image {
                                    GlidePDFKitImageAnnotation(model: annotation,scale: item.scale).position(annotation.location)
                                } else {
                                    GlidePDFKitTextAnnotation(model: annotation, scale: item.scale).position(annotation.location)
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
//                resetScale()
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
