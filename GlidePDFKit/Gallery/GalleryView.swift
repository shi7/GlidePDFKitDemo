import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var dataModel: DataModel
    @State var activePage: Int = 1
    var body: some View {
        GeometryReader { geo in
            ZoomableView(size: CGSize(width: geo.size.width, height: geo.size.height), min: 1.0, max: 6.0) {
                VTabView(selection: $activePage) {
                    ForEach(dataModel.items) { item in
                        GalleryItemView(width: geo.size.width, height: geo.size.height, item: item)
                            .aspectRatio(1, contentMode: .fit)
                            .tag(item.pageNumber)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: activePage, perform: { index in
                    print("new page \(index)")
                    dataModel.currentScale = 1.0
                })
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        Group{}
    }
}
