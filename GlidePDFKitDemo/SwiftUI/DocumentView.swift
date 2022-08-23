//
//  DocumentView.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/19.
//

import SwiftUI

struct DocumentView: View {
    let url: URL
    let model = ViewModel()
    @State private var selectedAnnotationId: UUID?
    var body: some View {

        let pdfData = try! Data(contentsOf: url)
        VStack {
            GalleryView(dataModel: model, activePage: 1)
//                .environmentObject(model)
                .setDelegate(delegate: self)
                .loadData(cfData: pdfData as CFData)

            if selectedAnnotationId == nil {
                AnnotationsTabsView(color: .lightGreen, readOnly: false)
                    .onSelect { annotationKind in
                        print("OnSelect: \(annotationKind.rawValue)")
                    }
            } else {
                AnnotationActionsView()
            }
        }
        .navigationTitle("PDF viewer")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension DocumentView: PDFDelegate {
    func onDocumentPreLoad() {
        print("DocumentView onDocumentPreLoad")
    }

    func onDocumentLoadedFail(_ error: PDFError) {
        print("DocumentView onDocumentLoadedFail")
    }

    func onDocumentLoaded() {
        print("DocumentView onDocumentLoaded")
    }

    func annotationDidTap(annotation: GlidePDFKitAnnotationModel) {

    }

}

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView(url: URL(string: "Preview")!)
    }
}
