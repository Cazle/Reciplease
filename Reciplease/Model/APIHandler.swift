
protocol APICall {
    func request(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void)
}
import Foundation
import Alamofire

final class APIHandler: APICall {
   
    func request(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void) {
        AF.request(url, method: .get).responseDecodable(of: APIRequestModel.self) { response in
            print(response.result)
            switch response.result {
            case .success(let dataDecoded):
                for hit in dataDecoded.hits {
                    print(hit.recipe.url)
                    print(hit.recipe.ingredientLines)
                }
            case .failure:
                print("Oui")
            }
        }
    }
}
