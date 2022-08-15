import Foundation
import UIKit
import SwiftUI

class DataModel: ObservableObject {
    
    @Published var items: [Item] = []
    var fetcher: ImageFetcher?
    
    
    func setPages(pages: Int) {
        for index in 1...pages {
            items.append(Item(index: index))
        }
    }
    
    func addData(uiImgs: [UIImage]? = nil) {
//        if let imgs = uiImgs {
//            items.append(contentsOf: imgs.map{ Item(img: Image(uiImage: $0))})
//        }
    }
    
    func fetchImage(index: Int) async -> Image? {
        guard let imgFetcher = fetcher, let uiImage = await imgFetcher.fetchBy(index: index) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
}

protocol ImageFetcher {
    func fetchBy(index: Int) async -> UIImage?
}

