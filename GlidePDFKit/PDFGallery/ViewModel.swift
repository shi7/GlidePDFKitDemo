import Foundation
import SwiftUI

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class ViewModel: ObservableObject {
    @Published var items: [GalleryItem] = []
    var fetcher: ImageFetcher?
    var activePage: Int = 1

    func setPages(pages: Int) {
        guard pages > 0 else {
            #if DEBUG
            print("pages less than 0, may something wrong!")
            #endif
            return
        }
        
        for pageNum in 1...pages {

            // --  TEST CODE
            let galleryItem = GalleryItem()
            galleryItem.pageNumber = pageNum

            var model = GlidePDFKitAnotationModel(location:CGPoint(x: UIScreen.main.bounds.width/2, y:     UIScreen.main.bounds.height/2) , width: 200, height: 100, type: .image)
            model.image = UIImage(named: "plus")
            galleryItem.anotationArray = [model]
            // --  TEST CODE

            items.append(galleryItem)
        }
    }
    
    func fetchImageAt(page: Int) async -> UIImage? {
        #if DEBUG
        print("try to fetch image at page: \(page)")
        #endif
        return await fetcher?.fetchAt(page: page)
    }

    func addNewAnotation(type: GlidePDFKitAnotationType) {
        var model = GlidePDFKitAnotationModel(location: CGPoint(x: 150, y: 210), width: 150, height: 40, type: type)
        if type == .image {
            model.image = UIImage(named: "draw")
        } else if type == .text {
            model.text = "text annotation"
        }
        addAnotations(anotations: [model], page: activePage)
    }

    func addAnotations(anotations: [GlidePDFKitAnotationModel]) {
        addAnotations(anotations: anotations, page: activePage)
    }

    func updateAnotations(anotations: GlidePDFKitAnotationModel) {
        guard let galleryItem = items[safe: (activePage - 1)],
              let anotationArray = galleryItem.anotationArray else {
                  return
              }
        galleryItem.anotationArray = anotationArray.map {
            if anotations.id == $0.id {
                return anotations
            }
            return $0
        }

    }

    func addAnotations(anotations: [GlidePDFKitAnotationModel], page: Int) {
        guard let galleryItem = items[safe: (page - 1)] else { return }
        galleryItem.anotationArray?.append(contentsOf: anotations)
        items[page - 1] = galleryItem
    }

    func updateActivePage(_ newActivePage: Int) {
        activePage = newActivePage
    }

    func removeSelectedAnotations() {
        removeSelectedAnotations(page: activePage)
    }

    func removeSelectedAnotations(page:Int) {
        guard let galleryItem = items[safe: (page - 1)],
              let anotationArray = galleryItem.anotationArray else {
                  return
              }
        galleryItem.anotationArray = anotationArray.filter { anotationModel in
            return !anotationModel.isSelected
        }
        items[page - 1] = galleryItem
    }
}

