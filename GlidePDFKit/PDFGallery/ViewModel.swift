import Foundation
import SwiftUI

private extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class ViewModel: ObservableObject {
    @Published var items: [GalleryItem] = []
    @Published var activePage: Int = 1
    var fetcher: ImageFetcher?

    func setPages(pages: Int) {
        guard pages > 0 else {
            // MARK: Debug
            print("pages less than 0, may something wrong!")
            return
        }

        for pageNum in 1 ... pages {
            // --  TEST CODE
            let galleryItem = GalleryItem()
            galleryItem.pageNumber = pageNum

            var model = GlidePDFKitAnnotationModel(location: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2), width: 70, height: 30, type: .image)
            model.image = UIImage(named: "plus")
            galleryItem.anotationArray = [model]
            // --  TEST CODE

            items.append(galleryItem)
        }
    }

    func fetchImageAt(page: Int) -> UIImage? {
        // MARK: Debug
        print("try to fetch image at page: \(page)")
        return fetcher?.fetchAt(page: page)
    }

    func addNewAnotation(type: GlidePDFKitAnotationType) {
        var model = GlidePDFKitAnnotationModel(location: CGPoint(x: 150, y: 210), width: 150, height: 40, type: type)
        if type == .image {
            model.image = UIImage(named: "draw")
            model.width = 60
        } else if type == .text {
            model.text = "text annotation"
        }
        addAnotations(anotations: [model], page: activePage)
    }

    func addAnotations(anotations: [GlidePDFKitAnnotationModel]) {
        addAnotations(anotations: anotations, page: activePage)
    }

    func addAnotations(anotations: [GlidePDFKitAnnotationModel], page: Int) {
        guard let galleryItem = items[safe: page - 1] else { return }
        galleryItem.anotationArray?.append(contentsOf: anotations)
        items[page - 1] = galleryItem
    }

    func updateAnotations(anotation: GlidePDFKitAnnotationModel, isNewSelected: Bool = false) {
        guard let galleryItem = items[safe: activePage - 1],
              let anotationArray = galleryItem.anotationArray else { return }
        galleryItem.anotationArray = anotationArray.map {
            if anotation.id == $0.id { return anotation }
            return $0
        }
    }

    func updateActivePage(_ newActivePage: Int) {
        activePage = newActivePage
    }

    func removeSelectedAnotations() {
        removeSelectedAnotations(page: activePage)
    }

    func removeSelectedAnotations(page: Int) {
        guard let galleryItem = items[safe: page - 1],
              let anotationArray = galleryItem.anotationArray else {
                  return
              }
        galleryItem.anotationArray = anotationArray.filter { anotationModel in
            !anotationModel.isSelected
        }
        items[page - 1] = galleryItem
    }
}
