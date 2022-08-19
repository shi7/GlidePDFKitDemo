import SwiftUI

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        guard width > 0 else { return Path() }
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct RoundedBackgroundModifier: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(color)
        )
    }
}

extension View {
    func roundedBackground(_ color: Color, cornerRadius: CGFloat = 4) -> some View {
        modifier(RoundedBackgroundModifier(color: color, cornerRadius: cornerRadius))
    }
}


