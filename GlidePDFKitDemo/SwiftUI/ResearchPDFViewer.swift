//
//  PDFViewer.swift
//  GlidePDFKitDemo
//
//  Created by Qinchao Xu on 2022/9/8.
//

import SwiftUI
import PDFKit

struct ResearchPDFViewer: View {
    let pdfFileUrl = Bundle.main.url(forResource: "big", withExtension: "pdf")!
    var document: PDFDocument {
        PDFDocument(url: pdfFileUrl)!
    }
    @State var index: UInt = 0
    
    var body: some View {
        PDFViewer(document, index: $index)
    }
}

struct ResearchPDFViewer_Previews: PreviewProvider {
    static var previews: some View {
        ResearchPDFViewer()
    }
}
