import Foundation
import UIKit
import SwiftUI

class DataModel: ObservableObject {
    
    @Published var items: [Item] = []
    
    func addData(uiImgs: [UIImage]? = nil) {
        if let imgs = uiImgs {
            items.append(contentsOf: imgs.map{ Item(img: Image(uiImage: $0))})
        }
    }
}

