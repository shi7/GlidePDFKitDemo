import Foundation
import UIKit

class PDFLoader: ImageFetcher {
    var delegate: PDFDelegate? = nil
    var processor: ProcessProtocol? = nil

    func loadPDF(url: URL?) {
        guard let url = url else { return }

        delegate?.onDocumentPreLoad()
        DispatchQueue.global().async { [self] in
            var data: Data? = nil
            if (url.scheme == "http" || url.scheme == "https") {
                data = FileCache.getFile(url: url)
                if (data == nil) {
                    data = try? Data(contentsOf: url)
                    FileCache.saveFile(url: url, data: data)
                }
            } else {
                data = try? Data(contentsOf: url)
            }

            DispatchQueue.main.async {
                if let data = data {
                    processor = data.dispatchProcessor()
                    delegate?.onDocumentLoaded()
                } else {
                    delegate?.onDocumentLoadedFail(.ParseError("Wrong URL"))
                }
            }
        }
    }
    
    func totalPages() -> Int {
        processor?.pageCount ?? 0
    }
    
    func fetchAt(page: Int) async -> UIImage? {
        processor?.loadPageAt(page)?.image
    }
}
