import Foundation

protocol ProcessProtocol {
    var pageCount: Int { get }
    func loadPageAt(_ index: Int) -> Page?
}
