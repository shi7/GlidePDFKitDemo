/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI

struct GalleryItemView: View {
    let width: Double
    let height: Double
    let item: Item

    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: item.url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: width, height: height)
        }
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        if let url = Bundle.main.url(forResource: "bobcat", withExtension: "jpg") {
            GalleryItemView(width: 50, height: 50, item: Item(url: url))
        }
    }
}
