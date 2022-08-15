import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let pageNumber: Int
}

extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}
