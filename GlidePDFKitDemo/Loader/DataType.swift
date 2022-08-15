//
//  DataType.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/12.
//

import Foundation

enum DataType {
    case PDF, Image
}

extension Data {
    func isPDF() -> Bool {
        return getDataType() == "pdf"
    }

    func isImage() -> Bool {
        return ["png", "jpg", "bmp", "unknown image"].contains{ getDataType() == $0 }
    }

    private func getDataType() -> String {
        let bytes = self.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: 2))
        }

        switch (bytes) {
        case [137, 80]:
            return "png"
        case [255, 216]:
            return "jpg"
        case [66, 77]:
            return "bmp"
        case [37, 80]:
            return "pdf"
        case [123, 34]:
            return "unknown image"
        default:
            return ""
        }
    }

    func dispatchProcessor() -> ProcessProtocol {
        if (isPDF()) {
            return PdfProcessor(data: self)
        } else {
            return ImageProcessor(data: self)
        }
    }
}
