import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(
        from urlString: String,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("DutchLearningApp/1.0 (iOS; educational)", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30
        
        session.dataTask(with: request) { data, response, error in
            if let error = error as? URLError {
                completion(.failure(self.handleURLError(error)))
                return
            } else if error != nil {
                // Если какая-то другая ошибка
                completion(.failure(.networkError(error?.localizedDescription ?? "Unknown error")))
                return
            }
        
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.decodingError))
                }
                
            case 404:
                completion(.failure(.wordNotFound))
            case 403:
                completion(.failure(.forbidden))
            case 429:
                completion(.failure(.rateLimited))
            default:
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
            }
            
        }.resume()
    }
    
    private func handleURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet:
            return .noInternet
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        default:
            return .networkError(error.localizedDescription)
        }
    }
}
