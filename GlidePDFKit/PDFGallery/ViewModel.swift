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
    var fetcher: GliderPDFService?

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

            var model = GlidePDFKitAnnotationModel(type: .image, location: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2), width: 70, height: 30)
            model.image = UIImage(named: "plus")
            galleryItem.annotationsArray = [model]
            // --  TEST CODE

            items.append(galleryItem)
        }
    }

    func fetchImageAt(page: Int) -> UIImage? {
        // MARK: Debug
        print("try to fetch image at page: \(page)")
        return fetcher?.fetchAt(page: page)
    }

    func addNewAnnotation(type: GlidePDFKitAnnotationType) {
        var model = GlidePDFKitAnnotationModel(type: type, location: CGPoint(x: 150, y: 210), width: 150, height: 40)
        if type == .image {
            model.image = UIImage(named: "draw")
            model.width = 60
        } else if type == .text {
            model.text = "text annotation"
        }
        addAnnotations(annotations: [model], page: activePage)
    }

    func addAnnotations(annotations: [GlidePDFKitAnnotationModel]) {
        addAnnotations(annotations: annotations, page: activePage)
    }

    func addAnnotations(annotations: [GlidePDFKitAnnotationModel], page: Int) {
        guard let galleryItem = items[safe: page - 1] else { return }
        galleryItem.annotationsArray?.append(contentsOf: annotations)
        items[page - 1] = galleryItem
    }

    func updateAnnotations(annotation: GlidePDFKitAnnotationModel, isNewSelected: Bool = false) {
        guard let galleryItem = items[safe: activePage - 1],
              let annotationArray = galleryItem.annotationsArray else { return }
        galleryItem.annotationsArray = annotationArray.map {
            if annotation.id == $0.id {
                return annotation
            }
            return $0
        }
        items[activePage - 1] = galleryItem
    }

    func didTap(annotation: GlidePDFKitAnnotationModel){
        fetcher?.annotationDidTap(annotation: annotation)
    }

    func updateActivePage(_ newActivePage: Int) {
        activePage = newActivePage
    }

    func removeSelectedAnnotations() {
        removeSelectedAnnotations(page: activePage)
    }

    func removeSelectedAnnotations(page: Int) {
        guard let galleryItem = items[safe: page - 1],
              let annotationArray = galleryItem.annotationsArray else {
                  return
              }
        galleryItem.annotationsArray = annotationArray.filter { annotationModel in
            !annotationModel.isSelected
        }
        items[page - 1] = galleryItem
    }
}
