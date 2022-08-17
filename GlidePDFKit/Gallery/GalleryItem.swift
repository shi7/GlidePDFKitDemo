import SwiftUI

class GalleryItem: ObservableObject,Identifiable {
    let id = UUID()
    var pageNumber: Int = 0
    var anotationArray: [AnotationModel]?
}
