import Foundation

class Request {
    enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    let requestUrl: URL?
    let method: RequestMethod
    let data: [String: Any]?
    let headers: [String: String]?
        
    init(url: URL?, method: RequestMethod, data: [String: Any]? = [:], headers: [String: String]? = [:]) {
        requestUrl = url
        self.method = method
        self.data = data
        self.headers = headers
    }
        
    func send (completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let requestUrl = requestUrl else { return }
        
        guard var components = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false) else { return }
        
        let queryItems = generateQueryItems()
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let query = components.url?.query else { return }
        var request = URLRequest(url: requestUrl)
        
        request.httpMethod = method.rawValue
        request.httpBody = Data(query.utf8)
        setRequestHeaders(of: &request)
                
        // Send HTTP Request
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    private func generateQueryItems() -> [URLQueryItem] {
        guard let data = data else { return [] }
        
        var queryItems: [URLQueryItem] = []
        
        for (name, value) in data {
            queryItems.append(URLQueryItem(name: name, value: String(describing: value)))
        }
        
        return queryItems
    }
    
    private func setRequestHeaders(of request: inout URLRequest) {
        guard let headers = headers else { return }
        
        for (name, value) in headers {
            request.setValue(value, forHTTPHeaderField: name)
        }
    }
}
