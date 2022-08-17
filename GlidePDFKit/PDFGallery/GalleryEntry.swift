//
//  GalleryEntry.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/11.
//

import SwiftUI

struct GalleryEntry: View {
    var pages: Int = 0
    var imgFetcher: ImageFetcher
    @ObservedObject var dataModel = ViewModel()

    init(pages: Int, fetcher: ImageFetcher) {
        self.pages = pages
        imgFetcher = fetcher
    }

    func addAnotations(type: GlidePDFKitAnotationType) {
        dataModel.addNewAnotation(type: type)
    }

    func removeSelectedAnotations() {
        dataModel.removeSelectedAnotations()
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
