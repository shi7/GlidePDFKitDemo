import SwiftUI

struct AnnotationsTabsView: View {
    private let annotationKinds: [Forms_Annotation.Kind] = [.signatureTab, .initialsTab, .dateTab, .radio, .checkbox, .text, .dropdown, .name, .email, .phone, .company, .license, .pdfStrikeoutLine]

    let color: Color
    let readOnly: Bool
    private let select: (Forms_Annotation.Kind) -> Void
    @State private var frame: CGRect = .zero

    init(color: Color, readOnly: Bool) {
        self.init(
            color: color,
            readOnly: readOnly,
            select: { _ in }
        )
    }

    private init(
        color: Color,
        readOnly: Bool,
        select: @escaping (Forms_Annotation.Kind) -> Void
    ) {
        self.color = color
        self.readOnly = readOnly
        self.select = select
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(visibleAnnotations, id: \.self) { annotation in
                    AnnotationTabView(
                        title: annotation.label,
                        color: color,
                        icon: Image(annotation.iconName)
                    )
                    .frame(width: 72)
                    .onTapGesture { select(annotation) }
//                    .if(visibleAnnotations.first == annotation) {
//                        $0.padding(.leading)
//                    }
//                    .if(visibleAnnotations.last == annotation) {
//                        $0.padding(.trailing)
//                    }
                }
            }
            .padding(.vertical, 20)
            .frame(minWidth: frame.width)
        }
        .geometryReader($frame)
        .border(width: 1, edges: [.top], color: .gray40)
    }

    func onSelect(_ select: @escaping (Forms_Annotation.Kind) -> Void) -> Self {
        .init(
            color: color,
            readOnly: readOnly,
            select: select
        )
    }

    private var visibleAnnotations: [Forms_Annotation.Kind] {
        annotationKinds.filter { !readOnly || $0.isReadOnlyVisible }
    }
}

private extension AnnotationsTabsView {
    struct AnnotationTabView: View {
        let title: String
        let color: Color
        let icon: Image

        var body: some View {
            VStack {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(16)
                    .background(
                        Circle()
                            .strokeBorder(Color.gray40)
                            .background(Circle().fill(color))
                    )

                Text(title)
                    .font(.caption)
                    .foregroundColor(.black)
                    .padding(.top, 4)
            }
        }
    }
}

struct AnnotationsTabsView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationsTabsView(color: .lightGreen, readOnly: false)
        AnnotationsTabsView(color: .gray40, readOnly: true)
    }
}
