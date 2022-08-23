import Foundation
import UIKit

class PDFLoader: GliderPDFService {
    var delegate: PDFDelegate?
    var processor: ProcessProtocol?

    func loadPDF(url: URL?) {
        guard let url = url else { return }

        delegate?.onDocumentPreLoad()
        DispatchQueue.global().async { [self] in
            var data: Data?
            if url.scheme == "http" || url.scheme == "https" {
                data = PDFFileCache.shareInstance.getFile(url: url)
                if data == nil {
                    data = try? Data(contentsOf: url)
                    PDFFileCache.shareInstance.saveFile(url: url, data: data)
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
    
    public func loadData(cfData: CFData?) {
        delegate?.onDocumentPreLoad()
        guard let data = cfData else {
            delegate?.onDocumentLoadedFail(.ParseError("Empty data"))
            return
        }
        processor = (data as Data).dispatchProcessor()
        delegate?.onDocumentLoaded()
    }

    func totalPages() -> Int {
        processor?.pageCount ?? 0
    }

    func fetchAt(page: Int) -> UIImage? {
        processor?.loadPageAt(page)?.image
    }

    func annotationDidTap(annotation: GlidePDFKitAnnotationModel) {
        delegate?.annotationDidTap(annotation: annotation)
    }
}
