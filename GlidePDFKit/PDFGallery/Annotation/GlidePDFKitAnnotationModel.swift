import Foundation
import SwiftUI

struct GlidePDFKitAnnotationModel: Identifiable {
    var id = UUID()
    var type: GlidePDFKitAnnotationType
    var location: CGPoint
    var width: CGFloat
    var height: CGFloat
    var image: UIImage?
    var text = ""
    var isSelected: Bool = false
    var backgroundColor: Color = .gray
}

enum GlidePDFKitAnnotationType {
    case image, text
}
