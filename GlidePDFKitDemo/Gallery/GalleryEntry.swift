//
//  GalleryEntry.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/11.
//

import SwiftUI

struct GalleryEntry: View {
    @StateObject var dataModel = DataModel()

    var body: some View {
        NavigationView {
            GalleryView()
        }
        .environmentObject(dataModel)
        .navigationViewStyle(.stack)
//        Text("Hello Word")
    }
}

struct GalleryEntry_Previews: PreviewProvider {
    static var previews: some View {
        GalleryEntry()
    }
}
