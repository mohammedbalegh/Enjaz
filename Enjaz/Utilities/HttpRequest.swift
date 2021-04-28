import Foundation

struct HttpRequest {
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    let requestUrl: URL?
    let method: HttpMethod
    let body: [String: Any]?
    let headers: [String: String]?
        
    init(url: URL?, method: HttpMethod, body: [String: Any]? = [:], headers: [String: String]? = [:]) {
        requestUrl = url
        self.method = method
        self.body = body
        self.headers = headers
    }
        
    func send(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let requestUrl = requestUrl, var components = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false) else { return }
        
        let queryItems = generateQueryItems()
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        var request = URLRequest(url: requestUrl)
        
        request.httpMethod = method.rawValue
        
        if method != .get {
            guard let query = components.url?.query else { return }
            request.httpBody = Data(query.utf8)
        }
        
        setRequestHeaders(of: &request)
        
        // Send HTTP Request
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    private func generateQueryItems() -> [URLQueryItem] {
        guard let body = body else { return [] }
        
        var queryItems: [URLQueryItem] = []
        
        for (name, value) in body {
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
