//
//  GalleryEntry.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/11.
//

import SwiftUI

struct GalleryEntry: View {
    let pdfImages: [UIImage]?
    @StateObject var dataModel = DataModel()

    init(images:[UIImage]? = nil) {
        pdfImages = images
    }
    
    var body: some View {
        NavigationView {
            GalleryView()
        }
        .environmentObject(dataModel)
        .navigationViewStyle(.stack)
        .onAppear {
            dataModel.addData(uiImgs: pdfImages)
        }
    }
}

struct GalleryEntry_Previews: PreviewProvider {
    static var previews: some View {
        GalleryEntry()
    }
}
