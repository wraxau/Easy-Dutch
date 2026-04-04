import Foundation

final class DictionaryRepository: DictionaryRepositoryProtocol {
    
    private let baseURL = "https://dictionaryapi.dev/api/v3/entries"
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func fetchWord(_ word: String, language: String, completion: @escaping (Result<DictionaryResponse, NetworkError>) -> Void) {
        
        guard !word.isEmpty, !language.isEmpty else {
            completion(.failure(.invalidParameter))
            return
        }
        
        guard let encodedWord = word.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let urlString = "\(baseURL)/\(language)/\(encodedWord)"
        
        networkService.fetch(from: urlString) { (result: Result<[DictionaryResponse], NetworkError>) in
            switch result {
            case .success(let entries):
                if let entry = entries.first {
                    completion(.success(entry))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
