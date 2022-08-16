import SwiftUI

struct GalleryItem: Identifiable {
    let id = UUID()
    let pageNumber: Int
}

extension GalleryItem: Equatable {
    static func ==(lhs: GalleryItem, rhs: GalleryItem) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}
