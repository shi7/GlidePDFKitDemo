import Foundation
import UIKit
import SwiftUI

class DataModel: ObservableObject {
    @Published var items: [Item] = []
    
    var fetcher: ImageFetcher?
    
    func setPages(pages: Int) {
        guard pages > 0 else {
#if DEBUG
            print("pages less than 0, may something wrong!")
#endif
            return
        }
        
        for pageNum in 1...pages {
            items.append(Item(pageNumber: pageNum))
        }
    }
    
    func fetchImageAt(page: Int) async -> Image? {
#if DEBUG
        print("try to fetch image at page: \(page)")
#endif
        guard let imgFetcher = fetcher, let uiImage = await imgFetcher.fetchAt(page: page) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
}

