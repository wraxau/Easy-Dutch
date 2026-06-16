import Foundation

final class DictionaryRepository: DictionaryRepositoryProtocol {
    
    private let baseURL = "https://dictionaryapi.dev/api/v3/entries"
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func fetchWord(_ word: String, language: String) async throws -> DictionaryResponse {
        guard !word.isEmpty, !language.isEmpty else {
            throw NetworkError.invalidParameter
        }

        guard let encodedWord = word.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw NetworkError.invalidURL
        }

        let urlString = "\(baseURL)/\(language)/\(encodedWord)"
        let entries: [DictionaryResponse] = try await networkService.fetch(from: urlString)

        guard let entry = entries.first else {
            throw NetworkError.noData
        }

        return entry
    }
}
