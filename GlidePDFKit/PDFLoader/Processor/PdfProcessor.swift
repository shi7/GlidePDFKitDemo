import CoreGraphics
import UIKit
import PDFKit

struct PdfProcessor: ProcessProtocol {
    let data: Data
    var pageCount: Int {
        cgDocument?.numberOfPages ?? 0
    }

    var cgDocument: CGPDFDocument? {
        let dataProvider = CGDataProvider(data: data as CFData)
        guard let dataProvider = dataProvider else { return nil }
        return CGPDFDocument(dataProvider)
    }

    var document: PDFDocument? {
        PDFDocument(data: data)
    }

    func loadPageAt(_ index: Int) -> Page? {
        guard let cgPDFPage = cgDocument?.page(at: index) else {
            return nil
        }

        let pageRect = cgPDFPage.getBoxRect(.mediaBox)
        let optionalImage: UIImage?

        if #available(iOS 11.0, *) {
            guard let pdfPage = document?.page(at: index - 1) else {
                return nil
            }
            optionalImage = pdfPage.thumbnail(of: pageRect.size, for: .mediaBox)
        } else {
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            optionalImage = renderer.image { ctx in
                UIColor.white.set()
                ctx.fill(pageRect)

                ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

                ctx.cgContext.drawPDFPage(cgPDFPage)
            }
        }

        guard let image = optionalImage else { return nil }

        return Page(
            index: index,
            width: Int(pageRect.width),
            height: Int(pageRect.height),
            image: image
        )
    }

    func loadPageCloseRange(_ start: Int, _ end: Int) -> [Page] {
        var pages: [Page] = []
        for index in start ... end {
            if let page = loadPageAt(index) {
                pages.append(page)
            }
        }
        return pages
    }
}
