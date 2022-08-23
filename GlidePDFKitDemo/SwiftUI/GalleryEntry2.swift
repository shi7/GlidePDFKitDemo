//
//  GalleryEntry2.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/19.
//

import SwiftUI

struct GalleryEntry2: View {
    @ObservedObject private var dataModel: ViewModel
    var url: URL?
    var delegate: PDFDelegate?

    let annotationService: AnnotationServiceProxy = .init()

    var processor: ProcessProtocol?

    init(model: ViewModel) {
        dataModel = model
        annotationService.service = model
    }

    var body: some View {
        GalleryView(dataModel: ViewModel(), activePage: 1)
            .environmentObject(dataModel)
    }

    public func loadData(cfData: CFData?) -> Self {
        var copy = self
        copy.delegate?.onDocumentPreLoad()
        guard let data = cfData else {
            delegate?.onDocumentLoadedFail(.ParseError("Empty data"))
            return copy
        }
        copy.processor = (data as Data).dispatchProcessor()
        copy.dataModel.setPages(pages: copy.processor?.pageCount ?? 0)
        copy.delegate?.onDocumentLoaded()
        return copy
    }

    public func setDelegate(delegate: PDFDelegate) -> Self {
        var copy = self
        copy.delegate = delegate
        return self
    }
}
