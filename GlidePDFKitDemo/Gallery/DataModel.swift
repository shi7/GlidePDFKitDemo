import Foundation
import UIKit
import SwiftUI

class DataModel: ObservableObject {
    @Published var items: [Item] = []
    
    var fetcher: ImageFetcher?
    
    func setPages(pages: Int) {
        for pageNum in 1...pages {
            items.append(Item(pageNumber: pageNum))
        }
    }
    
    func fetchImageAt(page: Int) async -> Image? {
        guard let imgFetcher = fetcher, let uiImage = await imgFetcher.fetchAt(page: page) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
}

