
protocol APICall {
    func request(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void)
}
import Foundation
import Alamofire

final class APIHandler: APICall {
   
    func request(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void) {
        AF.request(url, method: .get).response { response in
            
            switch response.result {
            case .success(let dataSuccess):
                guard let dataDecoded = try? JSONDecoder().decode(APIRequestModel.self, from: dataSuccess!) else {return}
                print(completion(.success(dataDecoded)))
                completion(.success(dataDecoded))
            case .failure(let error) :
                completion(.failure(error))
            }
        }
    }
}
