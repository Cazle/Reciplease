
protocol APICall {
    func request()
}


import Foundation
import Alamofire

final class APIHandler: APICall {
    
    func request() {
        print("Oui")
    }
}
