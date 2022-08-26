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
        let gotoPreviousPage: GotoPreviousPage = {
            if dataModel.activePage > 1 {
                withAnimation {
                    dataModel.activePage -= 1
                }
                return true
            } else {
                print("Current page is first page")
                return false
            }
        }
        
        let gotoNextPage: GotoNextPage = {
            if dataModel.activePage < dataModel.items.count {
                withAnimation {
                    dataModel.activePage += 1
                }
                return true
            } else {
                print("Current page is last page")
                return false
            }
        }
        
        // This will be called when image not scaled
        let onImgTapped: OnTapped = {
            dataModel.unSelectAnnotation()
        }
        
        ZStack {
            if let img = image {
                MagnificationView(
                    size: img.size,
                    gotoPreviousPage: gotoPreviousPage,
                    gotoNextPage: gotoNextPage,
                    onTapped:  onImgTapped
                ) {
                    ZStack {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                        
                        if let item = dataModel.items[safe: dataModel.activePage - 1], let annotationArray = item.annotationsArray {
                            ForEach(annotationArray) { annotation in
                                if annotation.type == .image || annotation.type == .checkbox {
                                    GlidePDFKitImageAnnotation(model: annotation, scale: item.scale)
                                } else if annotation.type == .text {
                                    GlidePDFKitTextAnnotation(model: annotation, scale: item.scale)
                                } else {
                                    GlidePDFKitLineAnnotation(model: annotation, scale: item.scale)
                                }
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        // This gesture called when image was scaled, it will not be called when image not scaled, because we have add a TapGesture in content
        .gesture(LongPressGesture(minimumDuration: 0.001).onEnded { _ in
            dataModel.unSelectAnnotation()
        })
        .onAppear {
            Task {
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
        }
        .frame(width: width, height: height, alignment: .center)
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
