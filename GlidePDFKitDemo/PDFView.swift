//
//  PDFView.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/11.
//

import Foundation
import UIKit

class PDFView: ImageFetcher {
    var delegate: PDFDelegate? = nil
    var processor: ProcessProtocol? = nil

    func loadPDF(url: URL?) {
        guard let url = url else { return }

        delegate?.onDocumentPreLoad()
        DispatchQueue.global().async { [self] in
            let data = try! Data(contentsOf: url)

            DispatchQueue.main.async {
                processor = data.dispatchProcessor()
                delegate?.onDocumentLoaded()
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
