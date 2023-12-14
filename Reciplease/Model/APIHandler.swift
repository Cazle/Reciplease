
protocol APICall {
    func request(url: URL)
}
import Foundation
import Alamofire

final class APIHandler: APICall {
    
    let urlEndpoint = URLEndpoint()
    
    func request(url: URL) {
        AF.request(url, method: .get).response { response in
            debugPrint(response)
        }
    }
}
