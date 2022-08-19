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
    @ObservedObject var dataModel = ViewModel()

    init(pages: Int, fetcher: GliderPDFService) {
        self.pages = pages
        imgFetcher = fetcher
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
                dataModel.setPages(pages: pages)
            }
    }
}

struct GalleryEntry_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}
