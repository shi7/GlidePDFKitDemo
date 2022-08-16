import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var dataModel: ViewModel
    @State var activePage: Int = 1
    var body: some View {
        GeometryReader { geo in
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
            })
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
