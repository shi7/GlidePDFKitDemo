//
//  PDFView.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/11.
//

import Foundation
import UIKit

class PDFView: ImageFetcher {
    var currentPageIndex = 0

    var delegate: PDFDelegate?
    var processor: ProcessProtocol?

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadPDF(url: URL?) {
        guard let url = url else { return }

        delegate?.onDocumentPreLoad()
        DispatchQueue.global().async { [self] in
            let pdfDocument: CGPDFDocument? = try? CGPDFDocument(url as CFURL)

            DispatchQueue.main.async {
                guard let document = pdfDocument else {
                    delegate?.onDocumentLoadedFail(PDFError.ParseError("Wrong URL."))
                    return
                }
                processor = PdfProcessor(document: document)
                delegate?.onDocumentLoaded()
            }
        }
    }

    // Only for this demo, will be deleted when release this
    func goPreviousPage() {
        currentPageIndex = currentPageIndex - 1 > 0 ? currentPageIndex - 1 : currentPageIndex
    }

    // Only for this demo, will be deleted when release this
    func goNextPage() {
        currentPageIndex = currentPageIndex < (processor?.pageCount ?? 0) ? currentPageIndex + 1 : currentPageIndex
    }
    
    func totalPages() -> Int {
        processor?.pageCount ?? 0
    }
    
    func fetchBy(index: Int) async -> UIImage? {
        processor?.loadPageAt(index)?.image
    }
}
