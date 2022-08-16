import Foundation

struct FileCache {

    static func saveFile(url: URL, data: Data?) {
        guard let data = data else { return }
        let cacheUrl = getCachePath(fileName: url.absoluteString.md5)
        try? data.write(to: cacheUrl)
    }
    static func getFile(url: URL) -> Data? {
        let cacheUrl = getCachePath(fileName: url.absoluteString.md5)
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: cacheUrl.path)) {
            return try? Data(contentsOf: cacheUrl)
        }
        return nil
    }

    static private func getCachePath(fileName: String) -> URL {
        let fileManager = FileManager.default
        let cachesDirectoryUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cachesDirectoryUrl.appendingPathComponent(fileName)
    }

    static func removeFile(url: URL) {
        let fileManager = FileManager.default
        let cacheUrl = getCachePath(fileName: url.absoluteString.md5)
        if (fileManager.fileExists(atPath: cacheUrl.path)) {
            try? fileManager.removeItem(at: cacheUrl)
        }
    }
}
