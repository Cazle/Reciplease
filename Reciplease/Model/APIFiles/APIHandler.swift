import Foundation
import Alamofire


protocol APICall {
    func request(url: URL, completion: @escaping (Data?, HTTPURLResponse?) -> Void)
}

final class APIHandler: APICall {
    
    func request(url: URL, completion: @escaping (Data?, HTTPURLResponse?) -> Void) {
        AF.request(url, method: .get).response {response in
            completion(response.data, response.response)
        }
    }
}



