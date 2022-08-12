import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var dataModel: DataModel

    var body: some View {
        VStack {
            GeometryReader { geo in
                ZoomableView(size: CGSize(width: geo.size.width, height: geo.size.height), min: 1.0, max: 6.0, showsIndicators: true) {
                    VTabView {
                        ForEach(dataModel.items) { item in
                            GeometryReader { geo in
                                GalleryItemView(width: geo.size.width, height: geo.size.height, item: item)
                            }
                            .cornerRadius(8.0)
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView().environmentObject(DataModel())
            .previewDevice("iPad (8th generation)")
    }
}
