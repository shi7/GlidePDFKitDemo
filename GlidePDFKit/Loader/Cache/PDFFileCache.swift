import Foundation
import Foundation
import QuartzCore

struct PDFFileCache {

    public static var shareInstance: PDFFileCache {
        PDFFileCache()
    }

    private let diskLruCache = DiskCache.shareInstance

    private init() {
        self.diskLruCache.costLimit = CacheDefaultCostLimit
        self.diskLruCache.countLimit = CacheDefaultCountLimit
    }

    func saveFile(url: URL, data: Data?) {
        guard let data = data else { return }
        let key = url.absoluteString.md5
        diskLruCache.set(object: data as NSCoding, forKey: key)
    }
    func getFile(url: URL) -> Data? {
        let key = url.absoluteString.md5
        return diskLruCache.object(forKey: key) as? Data
    }
}
