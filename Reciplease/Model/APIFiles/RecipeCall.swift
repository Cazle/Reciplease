import Foundation
import Alamofire

final class RecipeCall {
    let apiHandler = APIHandler()
    
    func requestRecipe(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void) {
        apiHandler.request(url: url) {response in
            switch response {
            case let .success((data, response)):
                completion(self.decode(data: data, response: response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func decode(data: Data, response: HTTPURLResponse) -> Result<APIRequestModel, Error> {
        guard response.statusCode == 200 else {
            return .failure(APIError.invalidStatusCode)
        }
        guard let dataDecoded = try? JSONDecoder().decode(APIRequestModel.self, from: data) else {
            return .failure(APIError.invalidDecoding)
        }
        return .success(dataDecoded)
    }
}
