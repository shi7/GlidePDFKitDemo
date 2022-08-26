import Foundation
import SwiftUI

public struct PDFKitBorderModifier: ViewModifier {
    let isCircle: Bool
    let showBorder: Bool

    var borderWidth: CGFloat {
        showBorder ? 2 : 0
    }
    let borderColor: Color = .blue
    @State private var width: CGFloat = 0
    @State private var height: CGFloat = 0

    init(_ isCircle: Bool, showBorder: Bool) {
        self.isCircle = isCircle
        self.showBorder = showBorder
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
                .cornerRadius(isCircle ? height / 2 : 0)
                .overlay(GeometryReader { geo -> AnyView in
                    DispatchQueue.main.async {
                        width = geo.size.width
                        height = geo.size.height
                    }
                    return AnyView(EmptyView())
                })

            if isCircle {
                Circle()
                    .stroke(borderColor, lineWidth: borderWidth)
                    .frame(width: width, height: height)
            } else {
                Rectangle()
                    .stroke(borderColor, lineWidth: borderWidth)
                    .frame(width: width, height: height)
            }
        }
    }
}
