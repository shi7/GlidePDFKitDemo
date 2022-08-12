//
//  PDFDelegate.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/12.
//

import Foundation

protocol PDFDelegate {

    func onDocumentPreLoad()
    func onDocumentLoadedFail(_ error: PDFError)
    func onDocumentLoaded()
}
