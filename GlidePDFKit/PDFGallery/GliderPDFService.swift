//
//  ImageFetcher.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/15.
//

import UIKit

protocol GliderPDFService {
    func annotationDidTap(annotation: GlidePDFKitAnnotationModel)

    func annotationEditTapped(_ id: String)
    func annotationFrameUpdate(_ id: String, _ frame: CGRect)
    func addAnnotationToFieldIdGroup(_ fieldId: String)
//    func annotationCreated(_ annotation: Mobile_ESignAnnotation)
    func annotationCreated()
    func annotationDeleted(_ id: String)
    func annotationEditCanceled()
}
