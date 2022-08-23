import SwiftUI

struct GalleryView: View {
    @ObservedObject var dataModel: ViewModel
    @State var activePage: Int = 1
    var body: some View {
        GeometryReader { geo in
            VTabView(selection: $dataModel.activePage) {
                ForEach(dataModel.items) { item in
                    GalleryItemView(width: geo.size.width, height: geo.size.height, item: item)
                        .aspectRatio(1, contentMode: .fit)
                        .tag(item.pageNumber)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: dataModel.activePage, perform: { index in

                // MARK: Debug

                print("new page \(index)")
            })
            .environmentObject(dataModel)
        }
    }

    public func setDelegate(delegate: PDFDelegate) -> Self {
        dataModel.delegate = delegate
        return self
    }

    public func loadData(cfData: CFData?) -> Self {
        dataModel.loadData(cfData: cfData)
        return self
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
