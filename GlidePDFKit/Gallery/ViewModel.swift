import Foundation
import UIKit
import SwiftUI

class ViewModel: ObservableObject {
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
    
    func fetchImageAt(page: Int) async -> UIImage? {
#if DEBUG
        print("try to fetch image at page: \(page)")
#endif
        
        return await fetcher?.fetchAt(page: page)
    }
}

