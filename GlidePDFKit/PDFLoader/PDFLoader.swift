import Foundation
import UIKit

class PDFLoader: GliderPDFService {
    func annotationEditTapped(_ id: String) {
        
    }

    func annotationFrameUpdate(_ id: String, _ frame: CGRect) {

    }

    func addAnnotationToFieldIdGroup(_ fieldId: String) {

    }

    func annotationCreated() {

    }

    func annotationDeleted(_ id: String) {

    }

    func annotationEditCanceled() {

    }

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

    func totalPages() -> Int {
        processor?.pageCount ?? 0
    }

    func annotationDidTap(annotation: GlidePDFKitAnnotationModel) {
        delegate?.annotationDidTap(annotation: annotation)
    }
}
