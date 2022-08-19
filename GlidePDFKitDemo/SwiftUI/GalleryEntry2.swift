//
//  GalleryEntry2.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/19.
//

import SwiftUI

struct GalleryEntry2: View {
    @ObservedObject private var dataModel: ViewModel
    let url: URL
    let pdfLoader: PDFLoader = .init()
    let annotationService: AnnotationServiceProxy = .init()

    private var documentPreLoadInner: (() -> Void)?
    private var documentLoadedFailInner: ((_ error: PDFError) -> Void)?
    private var documentLoadedInner: (() -> Void)?
    private var annotationSelectedInner: ((_ annotation: GlidePDFKitAnnotationModel) -> Void)?
    private var annotationUnSelectedInner: ((_ annotation: GlidePDFKitAnnotationModel) -> Void)?

    init(url: URL, model: ViewModel) {
        self.url = url
        dataModel = model
        dataModel.fetcher = pdfLoader
        pdfLoader.delegate = self
        pdfLoader.loadPDF(url: url)
        annotationService.service = model
    }

    private init(
        url: URL,
        model: ViewModel,
        annotationSelectedInner: ((_ annotation: GlidePDFKitAnnotationModel) -> Void)?,
        annotationUnSelectedInner: ((_ annotation: GlidePDFKitAnnotationModel) -> Void)?,
        onDocumentPreLoad: (() -> Void)?,
        onDocumentLoadedFail: ((_ error: PDFError) -> Void)?,
        onDocumentLoaded: (() -> Void)?
    ) {
        self.url = url
        dataModel = model
        self.annotationSelectedInner = annotationSelectedInner
        self.annotationUnSelectedInner = annotationUnSelectedInner
        documentPreLoadInner = onDocumentPreLoad
        documentLoadedFailInner = onDocumentLoadedFail
        documentLoadedInner = onDocumentLoaded
    }

    var body: some View {
        GalleryView()
            .environmentObject(dataModel)
    }
}

extension GalleryEntry2 {
    public func onDocumentPreLoad(_ preload: @escaping () -> Void) -> Self {
        var copy = self
        copy.documentPreLoadInner = preload
        copy.pdfLoader.delegate = copy
        return copy
    }

    public func onDocumentLoadedFail(_ loadedFail: @escaping (_ error: PDFError) -> Void) -> Self {
        var copy = self
        copy.documentLoadedFailInner = loadedFail
        copy.pdfLoader.delegate = copy
        return copy
    }

    public func onDocumentLoaded(_ loaded: @escaping () -> Void) -> Self {
        var copy = self
        copy.documentLoadedInner = loaded
        copy.pdfLoader.delegate = copy
        return copy
    }

    public func onAnnotationSelected(_ tap: @escaping (_ annotation: GlidePDFKitAnnotationModel) -> Void) -> Self {
        var copy = self
        copy.annotationSelectedInner = tap
        copy.pdfLoader.delegate = copy
        return copy
    }

    public func onAnnotationUnSelected(_ tap: @escaping (_ annotation: GlidePDFKitAnnotationModel) -> Void) -> Self {
        var copy = self
        copy.annotationUnSelectedInner = tap
        copy.pdfLoader.delegate = copy
        return copy
    }
}

extension GalleryEntry2: PDFDelegate {
    func onDocumentPreLoad() {
        documentPreLoadInner?()
    }

    func onDocumentLoadedFail(_ error: PDFError) {
        documentLoadedFailInner?(error)
    }

    func onDocumentLoaded() {
        dataModel.setPages(pages: pdfLoader.totalPages())
        documentLoadedInner?()
    }

    func annotationDidTap(annotation: GlidePDFKitAnnotationModel) {
        // TODO: navigator a new page to update annotation
        var newAnnotation = annotation
        newAnnotation.backgroundColor = .red
        newAnnotation.image = UIImage(named: "floodway")
        newAnnotation.text = "xxx"
        newAnnotation.isSelected = true
        annotationService.updateAnnotation(annotation: newAnnotation)
        annotationSelectedInner?(newAnnotation)
    }

    func annotationUnSelected(annotation: GlidePDFKitAnnotationModel) {
        annotationUnSelectedInner?(annotation)
    }
}

struct GalleryEntry2_Previews: PreviewProvider {
    static var previews: some View {
        let pdfUrl = Bundle.main.url(forResource: "big", withExtension: "pdf")!
        GalleryEntry2(url: pdfUrl, model: ViewModel())
    }
}
