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
    var isCircle: Bool = false

//    let page: Int
//    let color: UIColor
//    let PDFCoordinates: CGRect
//    let PDFScale: CGFloat
//    let minSize: CGSize
//    let kind: Forms_Annotation.Kind
//    let isRequired: Bool
//    let isReadOnly: Bool
//    let recipientText: String
//    let recipientColor: UIColor
//    let fieldId: String?
//    let fieldPart: Int?
//    let fieldValue: String?
//    let isChecked: Bool
//    let isBeingEdited: Bool

}

enum GlidePDFKitAnnotationType {
    case image, text, line, checkbox
}
