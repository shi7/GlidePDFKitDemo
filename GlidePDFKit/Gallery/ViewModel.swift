import Foundation
import SwiftUI

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class ViewModel: ObservableObject {
    @Published var items: [GalleryItem] = []
    var fetcher: ImageFetcher?
    
    func setPages(pages: Int) {
        guard pages > 0 else {
#if DEBUG
            print("pages less than 0, may something wrong!")
#endif
            return
        }
        
        for pageNum in 1...pages {

            // --  TEST CODE
            let galleryItem = GalleryItem()
            galleryItem.pageNumber = pageNum
            var model = AnotationModel(x:  UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, w: 200, h: 100, type: .Image)
            model.image = UIImage(named: "plus")
            galleryItem.anotationArray = [model]
            // --  TEST CODE

            items.append(galleryItem)
        }
    }
    
    func fetchImageAt(page: Int) async -> UIImage? {
#if DEBUG
        print("try to fetch image at page: \(page)")
#endif
        
        return await fetcher?.fetchAt(page: page)
    }

    func addAnotations(anotations: [AnotationModel], page: Int) {
        guard let galleryItem = items[safe: page] else { return }
        galleryItem.anotationArray?.append(contentsOf: anotations)
    }
}

