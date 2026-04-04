import Foundation

protocol DictionaryRepositoryProtocol {
    func fetchWord(_ word: String, language: String, completion: @escaping (Result<DictionaryResponse, NetworkError>) -> Void)
}
