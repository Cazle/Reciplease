import Foundation

enum APIError: Error {
    case invalidRequest
    case invalidResponse
    case invalidDecoding
    case invalidStatusCode
    case invalidData
}
