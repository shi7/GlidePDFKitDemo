import SwiftUI

struct GalleryItemView: View {
    let width: Double
    let height: Double
    let item: Item

    var body: some View {
        ZStack {
            item.img
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height, alignment: .center)
        }
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
