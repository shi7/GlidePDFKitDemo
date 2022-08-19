//
//  AnnotationService.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/19.
//

import Foundation

protocol AnnotationService {
    func addAnnotations(type: GlidePDFKitAnnotationType)

    func removeSelectedAnnotations()

    func updateAnnotation(annotation: GlidePDFKitAnnotationModel)
}

class AnnotationServiceProxy : AnnotationService {
    
    var service: AnnotationService?
    
    init() {
        self.service = nil
    }
    
    func setService(service: AnnotationService) {
        self.service = service
    }
    
    func addAnnotations(type: GlidePDFKitAnnotationType) {
        service?.addAnnotations(type: type)
    }
    
    func removeSelectedAnnotations() {
        service?.removeSelectedAnnotations()
    }
    
    func updateAnnotation(annotation: GlidePDFKitAnnotationModel) {
        service?.updateAnnotation(annotation: annotation)
    }
}
