//
//  PDFProcessor.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/12.
//

import Foundation

protocol ProcessProtocol {
    var pageCount: Int { get }
    func loadPageAt(_ index: Int) -> Page?
}
