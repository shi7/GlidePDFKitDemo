import Foundation

extension Data {
    func isPDF() -> Bool {
        return getDataType() == "pdf"
    }

    func isImage() -> Bool {
        return ["png", "jpg", "bmp", "unknown image"].contains{ getDataType() == $0 }
    }

    private func getDataType() -> String {
        let bytess: [UInt8] = self.withUnsafeBytes { dataBytes in
            let buffer: UnsafePointer<UInt8> = dataBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
            return [UInt8](UnsafeBufferPointer(start: buffer, count: 2))
        }

        switch (bytess) {
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
