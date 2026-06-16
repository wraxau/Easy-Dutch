import Foundation

protocol DictionaryRepositoryProtocol {
    func fetchWord(_ word: String, language: String) async throws -> DictionaryResponse
}
