import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    typealias UIViewType = PDFView

    let document: PDFDocument
    @Binding var index: UInt

    let pdfView = PDFView()

    init(_ document: PDFDocument, index: Binding<UInt>) {
        self.document = document
        self._index = index
    }

    func makeUIView(context: Context) -> UIViewType {
        context.coordinator.setListener()
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ view: UIViewType, context: Context) {
        let currentPageIndex = getCurrentPageIndex()

        if view.document != document {
            view.document = document
            pdfView.autoScales = true
//            guard document.page(at: 0) != nil else { return }
//            view.scaleFactor = view.scaleFactorForSizeToFit
//            view.minScaleFactor = view.scaleFactorForSizeToFit

            initialPage()
        } else if currentPageIndex != nil && currentPageIndex! != index {
            initialPage()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func getCurrentPageIndex() -> Int? {
        guard let page = pdfView.currentPage else { return nil }
        return pdfView.document?.index(for: page)
    }

    private func initialPage() {
        guard let targetPage = document.page(at: Int(index)) else { return }
        pdfView.go(to: targetPage)
    }

    func onPageIndexChanged() {
        guard let currentPageIndex = getCurrentPageIndex() else { return }
        print("0908 currentPageIndex \(currentPageIndex)")

        let documentView = pdfView.subviews[0].subviews[0]
        print("0908 \(documentView.classForCoder)")

        for subViewOfDocument in documentView.subviews {
            if subViewOfDocument.classForCoder.debugDescription().contains("PDFPageView") && subViewOfDocument.subviews.count < 1 {

                let commonAnnotation = UITextView()
                let currentPageIndex = getPageIndexFromPageView(subViewOfDocument)
                commonAnnotation.text = "Page: \(currentPageIndex + 1)"
                commonAnnotation.backgroundColor = .red
                subViewOfDocument.addSubview(commonAnnotation) { make in
                    make.width.height.equalTo(50)
                }
            }
        }
    }

    private func getPageIndexFromPageView(_ pageView: UIView) -> Int {
        if Dynamic(pageView).page.classForCoder.debugDescription.contains("PDFPage") {
            let page = Dynamic(pageView).page.asAnyObject as! PDFPage
            return pdfView.document?.index(for: page) ?? -1
        } else {
            return -1
        }
    }

    class Coordinator: NSObject {
        var glidePDFViewer: PDFViewer
        var observer: Any?

        init(_ glidePDFViewer: PDFViewer) {
            self.glidePDFViewer = glidePDFViewer
        }

        func setListener() {
            observer = NotificationCenter.default.addObserver(self, selector:#selector(pageDidChange(notification:)), name: Notification.Name.PDFViewPageChanged, object: nil)
        }

        @objc private func pageDidChange(notification: Notification) {
            glidePDFViewer.onPageIndexChanged()
        }

        deinit {
            if observer != nil {
                NotificationCenter.default.removeObserver(observer!)
            }
        }
    }
}
