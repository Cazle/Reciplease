import Foundation
import Alamofire


protocol APICall {
    func request(url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}

final class APIHandler: APICall {
    func request(url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        AF.request(url, method: .get).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    return completion(.failure(APIError.invalidData))
                }
                guard let response = response.response else {
                    return completion(.failure(APIError.invalidResponse))
                }
                completion(.success((data, response)))
            case .failure:
                completion(.failure(APIError.invalidRequest))
            }
        }
    }
}



