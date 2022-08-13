//
//  PDFView.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/11.
//

import Foundation
import UIKit

class PDFView: UIImageView {
    var currentPageIndex = 0

    var delegate: PDFDelegate?
    var processor: ProcessProtocol?

    init(_ url: URL? = nil) {
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFit

        loadPDF(url: url)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadPDF(url: URL?) {
        guard let url = url else { return }

        delegate?.onDocumentPreLoad()
        DispatchQueue.global().async { [self] in
            let data = try! Data(contentsOf: url)

            DispatchQueue.main.async {
                processor = data.dispatchProcessor()
                self.image = processor?.loadPageAt(1).image
                delegate?.onDocumentLoaded()
            }
        }
    }

    // Only for this demo, will be deleted when release this
    func goPreviousPage() {
        currentPageIndex = currentPageIndex - 1 > 0 ? currentPageIndex - 1 : currentPageIndex
        self.image = processor?.loadPageAt(currentPageIndex).image
    }

    // Only for this demo, will be deleted when release this
    func goNextPage() {
        currentPageIndex = currentPageIndex < (processor?.pageCount ?? 0) ? currentPageIndex + 1 : currentPageIndex
        self.image = processor?.loadPageAt(currentPageIndex).image
    }
}
