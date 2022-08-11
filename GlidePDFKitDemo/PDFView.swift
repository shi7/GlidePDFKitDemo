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
    var pdfImages: [UIImage]?

    func loadPDF(url: URL) {
        pdfImages = convertPDFPageToImage(url: url)
        self.image = pdfImages?[0]
    }

    func convertPDFPageToImage(url: URL) -> [UIImage]? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        var images: [UIImage] = []
        for index in 1...document.numberOfPages {
            let page = document.page(at: index)!
            let pageRect = page.getBoxRect(.mediaBox)
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            let img = renderer.image { ctx in
                UIColor.white.set()
                ctx.fill(pageRect)

                ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

                ctx.cgContext.drawPDFPage(page)
            }
            images.append(img)
        }

        return images
    }

    // Only for this demo, will be deleted when release this
    func goPreviousPage() {
        currentPageIndex = currentPageIndex - 1 > -1 ? currentPageIndex - 1 : currentPageIndex
        self.image = pdfImages?[currentPageIndex]
    }

    // Only for this demo, will be deleted when release this
    func goNextPage() {
        currentPageIndex = currentPageIndex + 1 < (pdfImages?.count ?? 0) ? currentPageIndex + 1 : currentPageIndex
        self.image = pdfImages?[currentPageIndex]
    }
}
