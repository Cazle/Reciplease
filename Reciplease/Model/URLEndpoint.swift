import Foundation

final class URLEndpoint {
    func URLRecipe(with ingredient: [String]) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/api/recipes/v2"
        
        let paramaters: [String: Any] = [
            "type": "public",
            "q": ingredient.joined(separator: "%"),
            "app_id": "cbfe9715",
            "app_key": "91e322d3c82707bcc618b8756198ac31"
        ]
        components.queryItems = paramaters.map { URLQueryItem(name: $0.key, value: "\($0.value)")}
        
       
        return components.url!
    }
}
