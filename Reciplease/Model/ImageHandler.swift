import Foundation

protocol ImageCall {
    func requestImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class ImageHandler: ImageCall {
    
    enum RequestError: Error {
        case invalidData
        case errorOccured
    }
    func requestImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data else {
                return completion(.failure(RequestError.invalidData))
            }
            guard error == nil else {
                return completion(.failure(RequestError.errorOccured))
            }
            completion(.success(data))
        }.resume()
    }
}
