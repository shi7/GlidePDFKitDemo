//
//  GalleryEntry.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/11.
//

import SwiftUI

struct GalleryEntry: View {
    var pages: Int = 0
    var imgFetcher: GliderPDFService
    var annotationServiceProxy: AnnotationServiceProxy
    var processor: ProcessProtocol?
    
    @StateObject var dataModel = ViewModel()

    init(pages: Int, fetcher: GliderPDFService, processor: ProcessProtocol?, proxy: AnnotationServiceProxy) {
        self.pages = pages
        imgFetcher = fetcher
        annotationServiceProxy = proxy
        self.processor = processor
    }

    func addAnnotations(type: GlidePDFKitAnnotationType) {
        dataModel.addNewAnnotation(type: type)
    }

    func removeSelectedAnnotations() {
        dataModel.removeSelectedAnnotations()
    }

    func updateAnnotations(annotation: GlidePDFKitAnnotationModel) {
        dataModel.updateAnnotations(annotation: annotation)
    }

    var body: some View {
        GalleryView()
            .environmentObject(dataModel)
            .onAppear {
                dataModel.fetcher = imgFetcher
                dataModel.processor = processor
                dataModel.setPages(pages: pages)
                annotationServiceProxy.service = dataModel
            }
    }
}

struct GalleryEntry_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
