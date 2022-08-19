import SwiftUI

struct GeometryGetter: View {
    let frame: (CGRect) -> Void
    var coordinateSpace: CoordinateSpace

    var body: some View {
        GeometryReader { geometry in
            makeView(geometry: geometry)
        }
    }

    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            frame(geometry.frame(in: coordinateSpace))
        }
        return Rectangle()
            .fill(Color.clear)
    }
}

extension View {
    func geometryReader(_ frame: @escaping (CGRect) -> Void, coordinateSpace: CoordinateSpace = .global) -> some View {
        background(GeometryGetter(frame: frame, coordinateSpace: coordinateSpace))
    }

    func geometryReader(_ frame: Binding<CGRect>, coordinateSpace: CoordinateSpace = .global) -> some View {
        background(GeometryGetter(frame: { frame.wrappedValue = $0 }, coordinateSpace: coordinateSpace))
    }
}
