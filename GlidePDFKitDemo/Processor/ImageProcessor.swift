//
//  ImageProcessor.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/12.
//

import Foundation
import UIKit

struct ImageProcessor: ProcessProtocol {
    let data: Data
    var pageCount = 1

    func loadPageAt(_ index: Int) -> Page {
        let image = UIImage.init(data: data)!
        return Page(
            index: 1,
            width: Int(image.size.width),
            height: Int(image.size.height),
            image: image
        )
    }
}
