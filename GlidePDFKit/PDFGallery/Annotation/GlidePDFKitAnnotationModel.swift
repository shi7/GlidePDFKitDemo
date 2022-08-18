import Foundation
import SwiftUI

struct GlidePDFKitAnnotationModel: Identifiable {
    var id = UUID()
    var location: CGPoint
    var width: CGFloat
    var height: CGFloat
    var type: GlidePDFKitAnotationType
    var image: UIImage?
    var text = ""
    var isSelected: Bool = false
    var backgroundColor: Color = .gray
}

enum GlidePDFKitAnotationType {
    case image, text
}
