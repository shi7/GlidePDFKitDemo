//
//  MainView.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/17.
//

import SwiftUI

struct MainView: View {
    @State private var text = "haha"

    let pdfFileUrl = Bundle.main.url(forResource: "big", withExtension: "pdf")!
    let pdfNetworkUrl = URL(string: "https://s3.amazonaws.com/prodretitle-east/9ebd31f734ad9ee3719ef97b/tt.pdf")!
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Read from File") {
                    DocumentView(url: pdfFileUrl)
                }
                .padding()

                NavigationLink("Read from URL") {
                    DocumentView(url: pdfNetworkUrl)
                }
                .padding()

                NavigationLink("PDFViewer") {
                    ResearchPDFViewer()
                }
                .padding()
            }
            .navigationTitle("Choose PDF source")
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(.stack)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
