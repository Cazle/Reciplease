
protocol APICall {
    func request(storedIngredient: [String])
}
import Foundation
import Alamofire

final class APIHandler: APICall {
    
    let urlEndpoint = URLEndpoint()
    
    func request(storedIngredient: [String]) {
        
        let url = urlEndpoint.URLRecipe(of: storedIngredient)
        AF.request(url, method: .get).response { response in
            debugPrint(response)
        }
    }
}
