import Foundation
import UIKit

struct ImageProcessor: ProcessProtocol {
    let data: Data
    var pageCount = 1

    func loadPageAt(_: Int) -> Page? {
        guard let image = UIImage(data: data) else {
            return nil
        }
        return Page(
            index: 1,
            width: Int(image.size.width),
            height: Int(image.size.height),
            image: image
        )
    }
}
