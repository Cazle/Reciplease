import Foundation
import Alamofire

final class DecodingRecipeModel {
    
    let apiHandler: APICall
    
    init(apiHandler: APICall = APIHandler()) {
        self.apiHandler = apiHandler
    }
    
    func requestRecipe(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void) {
        apiHandler.request(url: url) {data, response in
            guard let data = data else {
                return completion(.failure(APIError.invalidData))
            }
            guard let response = response else {
                return completion(.failure(APIError.invalidResponse))
            }
            completion(self.decode(data: data, response: response))
        }
    }
    func decode(data: Data, response: HTTPURLResponse) -> Result<APIRequestModel, Error> {
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
