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
        VStack {
            GalleryEntry2(url: url, model: model)
                .onDocumentPreLoad {
                    print("onDocumentPreLoad")
                }
                .onDocumentLoadedFail { _ in
                    print("onDocumentLoadedFail")
                }
                .onDocumentLoaded {
                    print("onDocumentLoaded")
                }
                .onAnnotationSelected { annotation in
                    print("onAnnotationDidTap: \(annotation)")
                    selectedAnnotationId = annotation.id
                }
                .onAnnotationUnSelected { annotation in
                    print("onAnnotationDidTap: \(annotation)")
                    selectedAnnotationId = nil
                }

            if (selectedAnnotationId == nil) {
                AnnotationsTabsView(color: .lightGreen, readOnly: false)
                    .onSelect{ annotationKind in
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

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView(url: URL(string: "Preview")!)
    }
}
