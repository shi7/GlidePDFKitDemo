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
        self.imgFetcher = fetcher
    }

    func addAnotations(type: AnotationType) {
        var model = AnotationModel(x: 150, y: 210, w: 200, h: 100, type: type)
        if type == .Image {
            model.image = UIImage(named: "draw")
        }
        self.dataModel.addAnotations(anotations: [model], page: 0)
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
