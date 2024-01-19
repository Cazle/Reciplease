@testable import Reciplease
import Foundation

final class APICallStub: APICall{
 
    let result: (Data?, HTTPURLResponse?)
    
    init(result: (Data?, HTTPURLResponse?)) {
        self.result = result
    }
    func request(url: URL, completion: @escaping (Data?, HTTPURLResponse?) -> Void) {
        completion(result.0, result.1)
    }
}
