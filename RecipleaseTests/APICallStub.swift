@testable import Reciplease
import Foundation

final class APICallStub: APICall {
    let result: Result<APIRequestModel, Error>
    
    init(result: Result<APIRequestModel, Error>) {
        self.result = result
    }
    func request(url: URL, completion: @escaping (Result<APIRequestModel, Error>) -> Void) {
        completion(result)
    }
}
class test {
    func testing() {
       
    }
}
