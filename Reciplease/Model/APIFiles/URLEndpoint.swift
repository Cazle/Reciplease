import Foundation

final class URLEndpoint {
    func urlRecipe(with ingredient: [String]) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/api/recipes/v2"
        
        
        components.queryItems = []
        components.queryItems?.append(.init(name: "type", value: "public"))
        components.queryItems?.append(.init(name: "q", value: ingredient.joined(separator: ",")))
        components.queryItems?.append(.init(name: "app_id", value: "cbfe9715"))
        components.queryItems?.append(.init(name: "app_key", value: "91e322d3c82707bcc618b8756198ac31"))
        
        return components.url!
    }
}
