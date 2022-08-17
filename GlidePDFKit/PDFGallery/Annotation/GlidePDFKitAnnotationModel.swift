import Foundation
import SwiftUI

struct GlidePDFKitAnnotationModel: Identifiable {
    var id = UUID()
    var location: CGPoint
    var width: CGFloat
    var height: CGFloat
    var type : GlidePDFKitAnotationType
    var image : UIImage?
    var text = ""
    var isSelected : Bool = false
}

enum GlidePDFKitAnotationType {
    case image, text
}
