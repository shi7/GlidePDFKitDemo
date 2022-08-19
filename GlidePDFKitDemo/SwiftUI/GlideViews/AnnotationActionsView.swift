import SwiftUI

struct AnnotationActionsView: View {

    @State private var frame: CGRect = .zero
    @State private var require: Bool = true

    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    AnnotationActionView(title: "Delete")
                        .destructive { print("Delete") }
                        .padding(.leading)

                    AnnotationActionView(title: "Required")
                        .checked($require)
                        .padding(.trailing)

                    AnnotationActionView(title: "Assign to")
                        .icon(.person) { print("Assign to") }
                        .padding(.trailing)
                }
                .padding(.vertical, 20)
                .frame(minWidth: frame.width)
            }
            .geometryReader($frame)
            .border(width: 1, edges: [.top], color: .gray40)
    }
}

fileprivate struct AnnotationActionView: View {
    private let title: String
    private let isDestructive: Bool
    private let content: () -> AnyView

    init(title: String) {
        self.init(title: title, destructive: false, content: { AnyView(EmptyView()) })
    }

    private init(title: String, destructive: Bool, content: @escaping () -> AnyView) {
        self.title = title
        self.isDestructive = destructive
        self.content = content
    }

    var body: some View {
        VStack {
            content()
                .frame(width: 24, height: 24)
                .padding(16)
                .background(
                    Circle()
                        .strokeBorder(Color.gray40)
                )

            Text(title)
                .padding(.top, 4)
        }
        .frame(width: 72)
        .foregroundColor(isDestructive ? .red : .black)
    }

    func destructive(_ action: @escaping () -> Void) -> some View {
        AnnotationActionView(
            title: title,
            destructive: true,
            content: content
        )
        .icon(.trashCan, action: action)
    }

    func icon(_ image: Icon, action: @escaping () -> Void) -> some View {
        AnnotationActionView(
            title: title,
            destructive: isDestructive,
            content: {
                AnyView(Text("Image: \(image.rawValue)"))
            }
        )
        .onTapGesture(perform: action)
    }

    func checked(_ value: Binding<Bool>) -> some View {
        AnnotationActionView(
            title: title,
            destructive: false,
            content: {
                AnyView(Text("\(String(value.wrappedValue))"))
            }
        )
        .onTapGesture { value.wrappedValue.toggle() }
    }
}
