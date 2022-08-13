//
//  ImageProcessor.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/12.
//

import CoreGraphics
import UIKit

struct PdfProcessor: ProcessProtocol {
    let data: Data
    var pageCount: Int {
        document.numberOfPages
    }
    var document: CGPDFDocument {
        let dataProvider = CGDataProvider(data: data as CFData)!
        return try! CGPDFDocument(dataProvider)!
    }

    func loadPageAt(_ index: Int) -> Page {
        let page = document.page(at: index)!
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return Page(
            index: index,
            width: Int(pageRect.width),
            height: Int(pageRect.height),
            image: image
        )
    }

    func loadPageCloseRange(_ start: Int, _ end: Int) -> [Page] {
        var pages: [Page] = []
        for index in start...end {
            pages.append(loadPageAt(index))
        }
        return pages
    }
}
