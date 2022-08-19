//
//  ImageFetcher.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/15.
//

import UIKit

protocol GliderPDFService {
    func fetchAt(page: Int) -> UIImage?

    func annotationDidTap(annotation: GlidePDFKitAnnotationModel)
}
