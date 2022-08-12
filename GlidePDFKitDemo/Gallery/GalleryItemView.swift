import SwiftUI

struct GalleryItemView: View {
    let width: Double
    let height: Double
    let item: Item

    var body: some View {
        ZStack(alignment: .topTrailing) {
            item.img
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
        }
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
