import SwiftUI

public struct ZoomableModifier: ViewModifier {
    
    private enum ZoomState {
        case inactive
        case active(scale: CGFloat)
        
        var scale: CGFloat {
            switch self {
            case .active(let scale):
                return scale
            default: return 1.0
            }
        }
    }
    
    private var contentSize: CGSize
    private var min: CGFloat = 1.0
    private var max: CGFloat = 3.0
    private var showsIndicators: Bool = false
    
    @GestureState private var zoomState = ZoomState.inactive
    @EnvironmentObject var dataModel: DataModel
//    @State private var currentScale: CGFloat = 1.0
    /**
     Initializes an `ZoomableModifier`
     - parameter contentSize : The content size of the views.
     - parameter min : The minimum value that can be zoom out.
     - parameter max : The maximum value that can be zoom in.
     - parameter showsIndicators : A value that indicates whether the scroll view displays the scrollable component of the content offset, in a way that’s suitable for the platform.
     */
    public init(contentSize: CGSize,
                min: CGFloat = 1.0,
                max: CGFloat = 3.0,
                showsIndicators: Bool = false) {
        self.contentSize = contentSize
        self.min = min
        self.max = max
        self.showsIndicators = showsIndicators
    }
    
    var scale: CGFloat {
        return dataModel.currentScale * zoomState.scale
    }
    
    var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($zoomState) { value, state, transaction in
                state = .active(scale: value)
            }
            .onEnded { value in
                var new = dataModel.currentScale * value
                if new <= min { new = min }
                if new >= max { new = max }
                dataModel.currentScale = new
            }
    }
    
    var doubleTapGesture: some Gesture {
        TapGesture(count: 2).onEnded {
            if scale <= min { dataModel.currentScale = max } else
            if scale >= max { dataModel.currentScale = min } else {
                dataModel.currentScale = ((max - min) * 0.5 + min) < scale ? max : min
            }
        }
    }
    
    public func body(content: Content) -> some View {
        ScrollView([.horizontal, .vertical], showsIndicators: showsIndicators) {
            content
                .frame(width: contentSize.width * scale, height: contentSize.height * scale, alignment: .center)
                .scaleEffect(scale, anchor: .center)
        }
        .gesture(ExclusiveGesture(zoomGesture, doubleTapGesture))
        .animation(.easeInOut, value: scale)
    }
}
