import Foundation

protocol PDFDelegate {

    func onDocumentPreLoad()
    func onDocumentLoadedFail(_ error: PDFError)
    func onDocumentLoaded()
}
