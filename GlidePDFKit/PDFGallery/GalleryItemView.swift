import SwiftUI

struct GalleryItemView: View {
    let width: Double
    let height: Double
    let item: GalleryItem
    
    @EnvironmentObject var dataModel: ViewModel
    @State var image: UIImage?
    
    func resetScale() {
        if let img = image {
            let scaleW = width / img.size.width
            let scaleH = height / img.size.height
            let trueScale = min(scaleW, scaleH)
            item.scale = trueScale
        }
    }
    
    var body: some View {
        let gotoPreviousPage = {
            if dataModel.activePage > 1 {
                withAnimation {
                    dataModel.activePage -= 1
                }
            } else {
                print("Current page is first page")
            }
        }
        
        let gotoNextPage = {
            if dataModel.activePage < dataModel.items.count {
                withAnimation {
                    dataModel.activePage += 1
                }
            } else {
                print("Current page is last page")
            }
        }
        
        ZStack {
            if let img = image {
                MagnificationView(size: img.size, gotoPreviousPage: gotoPreviousPage, gotoNextPage: gotoNextPage) {
                    ZStack {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                        if let item = dataModel.items[safe: dataModel.activePage - 1], let annotationArray = item.annotationsArray {
                            ForEach(annotationArray) { annotation in
                                if annotation.type == .image {
                                    GlidePDFKitImageAnnotation(model: annotation, scale: item.scale)
                                } else {
                                    GlidePDFKitTextAnnotation(model: annotation, scale: item.scale)
                                }
                            }
                        }
                    }.frame(width: img.size.width, height: img.size.height, alignment: .center)
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
                resetScale()
            }
            
            dataModel.preloadImageOf(page: item.pageNumber + 1)
        }
        .frame(width: width, height: height, alignment: .center)
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
