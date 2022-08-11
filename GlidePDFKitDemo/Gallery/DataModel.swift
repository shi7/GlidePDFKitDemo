/*
See the License.txt file for this sample’s licensing information.
*/

import Foundation

class DataModel: ObservableObject {
    
    @Published var items: [Item] = []
    
    init() {
        if let urls = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: nil) {
            for url in urls {
                let item = Item(url: url)
                items.append(item)
            }
        }
    }
}

