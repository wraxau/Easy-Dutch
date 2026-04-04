import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidParameter
    case invalidURL
    case noResponse
    case noData
    case decodingError
    case wordNotFound
    case forbidden
    case rateLimited
    case noInternet
    case timeout
    case cancelled
    case serverError(statusCode: Int)
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidParameter:
            return "Неверные параметры запроса"
        case .invalidURL:
            return "Некорректный URL"
        case .noResponse:
            return "Сервер не ответил"
        case .noData:
            return "Пустой ответ от сервера"
        case .decodingError:
            return "Ошибка обработки данных"
        case .wordNotFound:
            return "Слово не найдено в словаре"
        case .forbidden:
            return "Доступ запрещён (403)"
        case .rateLimited:
            return "Слишком много запросов, попробуйте позже"
        case .noInternet:
            return "Нет подключения к интернету"
        case .timeout:
            return "Время ожидания истекло"
        case .cancelled:
            return "Запрос отменён"
        case .serverError(let code):
            return "Ошибка сервера (\(code))"
        case .networkError(let message):
            return "Сетевая ошибка: \(message)"
        }
    }
}
