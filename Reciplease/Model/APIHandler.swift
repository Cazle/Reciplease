import Foundation
import Alamofire
import AlamofireImage


protocol APICall {
    func request(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void)
}

final class APIHandler: APICall {
   
    func request(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void) {
        AF.request(url, method: .get).response { response in
            switch response.result {
            case .success:
                guard let dataReceived = response.data else {
                    print(APIError.invalidData)
                    return completion(.failure(APIError.invalidData))
                }
                guard let response = response.response else {
                    print(APIError.invalidResponse)
                    return completion(.failure(APIError.invalidResponse))
                }
                let result = self.decode(data: dataReceived, response: response)
                completion(result)
            case .failure:
                print(APIError.invalidRequest)
                completion(.failure(APIError.invalidRequest))
            }
        }
    }
    
    private func decode(data: Data, response: HTTPURLResponse) -> Result<APIRequestModel, Error> {
        guard response.statusCode == 200 else {
            print(APIError.invalidStatusCode)
            return .failure(APIError.invalidStatusCode)
        }
        guard let dataDecoded = try? JSONDecoder().decode(APIRequestModel.self, from: data) else {
            print(APIError.invalidDecoding)
            return .failure(APIError.invalidDecoding)
        }
        return .success(dataDecoded)
    }
}


