import Foundation

protocol NetworkRequestBodyConvertible {
    var data: Data? { get }
    var queryItems: [URLQueryItem]? { get }
    var parameters: [String : Any]? { get }
}

final class Network {

    enum Result {
        case data(Data?)
        case error(Error)
    }

    enum Method: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
        case patch = "PATCH"
    }

    private var headers: [String : String] = [:]
    private var session = URLSession.shared

    private func makeRequest(_ method: Method, _ uri: URL, _ parameters: NetworkRequestBodyConvertible?) -> URLRequest {
        var request = URLRequest(url: uri)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        if method == .get {
            request.url?.append(queryItems: parameters?.queryItems ?? [])
        } else if method == .post {
            request.httpBody = parameters?.data
        }

        return request
    }

    func perform(_ method: Method, _ uri: URL, _ parameters: NetworkRequestBodyConvertible? = nil) async throws -> Data {
        let request = makeRequest(method, uri, parameters)
        let (data, _) = try await session.data(for: request)
        return data
    }

}












