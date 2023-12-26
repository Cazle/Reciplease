import Foundation
import Alamofire
import AlamofireImage


protocol APICall {
    func request(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void)
}

final class APIHandler: APICall {
   
    func request(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void) {
        AF.request(url, method: .get).responseDecodable(of: APIRequestModel.self) { response in
            switch response.result {
            case .success(let decodedResponse):
                completion(.success(decodedResponse))
            case .failure:
                completion(.failure(APIError.invalidRequest))
            }
        }
    }
}

