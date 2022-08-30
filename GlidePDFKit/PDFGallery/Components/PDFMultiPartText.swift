import Foundation
import SwiftUI

struct PDFMultiPartText: View {
    public static let DEFAULT_MARGIN: CGFloat = 4
    public static let DEFAULT_SIZE: CGFloat = 10
    public static let DEFAULT_FONT_SIZE: CGFloat = 7

    let fieldPart: String
    let heightAndWidth: CGFloat
    let fontSize: CGFloat
    let margin: CGFloat

    init(
        _ fieldPart: String,
        heightAndWidth: CGFloat = DEFAULT_SIZE,
        fontSize: CGFloat = DEFAULT_FONT_SIZE,
        margin: CGFloat = DEFAULT_MARGIN
    ) {
        self.fieldPart = fieldPart
        self.heightAndWidth = heightAndWidth
        self.fontSize = fontSize
        self.margin = margin
    }

    var body: some View {
        HStack(spacing: margin) {
            Text(fieldPart)
                .frame(width: heightAndWidth, height: heightAndWidth, alignment: .center)
                .font(.system(size: fontSize))
                .border(.black, width: 1)
                .background(Color.white)
            Spacer(minLength: 0)
        }
        .frame(width: heightAndWidth + margin, height: heightAndWidth, alignment: .center)
    }
}
