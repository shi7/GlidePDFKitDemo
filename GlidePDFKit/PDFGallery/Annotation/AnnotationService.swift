//
//  AnnotationService.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/19.
//

import Foundation

protocol AnnotationService {
    func addAnnotations(type: GlidePDFKitAnnotationType)

    func addAnnotations(_ model: [GlidePDFKitAnnotationModel])

    func removeSelectedAnnotations()

    func updateAnnotation(annotation: GlidePDFKitAnnotationModel)
}

class AnnotationServiceProxy: AnnotationService {
    var service: AnnotationService?

    init() {
        service = nil
    }

    func setService(service: AnnotationService) {
        self.service = service
    }

    func addAnnotations(type: GlidePDFKitAnnotationType) {
        service?.addAnnotations(type: type)
    }

    func addAnnotations(_ model: [GlidePDFKitAnnotationModel]) {
        service?.addAnnotations(model)
    }

    func removeSelectedAnnotations() {
        service?.removeSelectedAnnotations()
    }

    func updateAnnotation(annotation: GlidePDFKitAnnotationModel) {
        service?.updateAnnotation(annotation: annotation)
    }
}
