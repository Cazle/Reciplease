import Foundation

final class URLHandler {
    func URLRecipe(baseURL: URL) -> URL {
        
        let ingredientInStore = Ingredient()
        
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "/api/recipes/v2"
        
        let paramaters: [String: Any] = [
            "type": "public",
            "q": ingredientInStore.ingredients.joined(separator: ","),
            "app_id": "cbfe9715",
            "app_key": "91e322d3c82707bcc618b8756198ac31"
        ]
        components.queryItems = paramaters.map { URLQueryItem(name: $0.key, value: "\($0.value)")}
        
        if let url = components.url {
            print("Url is \(url)")
        } else {
            print("Rekt")
        }
        return components.url!
    }
}
