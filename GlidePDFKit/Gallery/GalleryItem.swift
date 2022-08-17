import SwiftUI

struct GalleryItem: Identifiable {
    let id = UUID()
    let pageNumber: Int
    var position = Position(100, 200)
    var size = CGSize(width: 100, height: 40)
    
    mutating func updatePosition(position: Position) {
        self.position = position
    }
}

extension GalleryItem: Equatable {
    static func ==(lhs: GalleryItem, rhs: GalleryItem) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}
