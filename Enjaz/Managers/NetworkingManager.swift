import UIKit

struct NetworkingManager {
    enum StatusCodeError: Error {
        case statusCode(code: Int)
    }
    
    enum EncodingError: Error {
        case invalidDataFormat
    }
    
    enum CallType {
        case video
        case article
        case bank
        case aboutUs
        case privacyPolicy
    }
    
    static let cache = NSCache<NSString, NSString>()
    
    static func signUp(user: UserModel, password: String, completionHandler: @escaping (_ token: String?, _ user: [String: Any]?, _ error: Error?) -> Void) {
        let url = URL(string: NetworkingUrls.apiSignupUrl)
        let data = [
            "username": user.username,
            "email": user.email,
            "password": password,
            "full_name": user.name,
        ]
        
        let request = HttpRequest(url: url, method: .post, body: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(nil, nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(nil, nil, StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            let dataDictionary = self.parseDataIntoDictionary(data: data)
            let token = dataDictionary?["token"] as? String
            let user = dataDictionary?["user"] as? [String: Any]
            
            completionHandler(token, user, nil)
        }
    }
    
    static func logIn(username: String, password: String, completionHandler: @escaping (_ token: String?, _ user: [String: Any]?, _ error: Error?) -> Void) {
        let url = URL(string: NetworkingUrls.apiLoginUrl)
        let data = [
            "username": username,
            "password": password,
        ]
        
        let request = HttpRequest(url: url, method: .post, body: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(nil, nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(nil, nil, StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            let dataDictionary = self.parseDataIntoDictionary(data: data)
            let token = dataDictionary?["token"] as? String
            let user = dataDictionary?["user"] as? [String: Any]
            
            completionHandler(token, user, nil)
        }
    }
    
    static func requestPasswordResetCode(email: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        let url = URL(string: NetworkingUrls.apiResetPasswordUrl)
        let data = [
            "email": email,
        ]
        
        let request = HttpRequest(url: url, method: .post, body: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            completionHandler(nil)
        }
    }
    
    static func resetPassword(newPassword: String, email: String, resetCode: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        let url = URL(string: NetworkingUrls.apiResetPasswordUrl)
        let data = [
            "email": email,
            "code": resetCode,
            "password": newPassword,
        ]
        
        let request = HttpRequest(url: url, method: .post, body: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            completionHandler(nil)
        }
    }
    
    static func requestEmailVerificationCode(email: String, password: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        let url = URL(string: NetworkingUrls.apiRequestEmailVerificationCodeUrl)
        let data = [
            "email": email,
            "password": password,
        ]
        
        let request = HttpRequest(url: url, method: .post, body: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            completionHandler(nil)
        }
    }
    
    static func verifyEmail(email: String, verificationCode: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        let url = URL(string: NetworkingUrls.apiEmailVerificationUrl)
        let data = [
            "email": email,
            "code": verificationCode,
        ]
        
        let request = HttpRequest(url: url, method: .post, body: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            completionHandler(nil)
        }
    }
    
    // @stub
    static func retrieveGoalSuggestions(completionHandler: @escaping ([GoalSuggestionsModel]?, Error?) -> Void) {
        
        let url = URL(string: NetworkingUrls.apiGoalsSuggestionsBankUrl)
        
        let request = HttpRequest(url: url, method: .get)
        
        request.send { data, response, error in
            
            if let _ = error {
                completionHandler(nil,  error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(nil, StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let dataAsString = NSString(string: String(decoding: data,as: UTF8.self))
            
            do {
                let bank = try encodeBlog(dataAsString, type: [GoalSuggestionsModel].self)
                completionHandler(bank, nil)
            } catch {
                completionHandler(nil, EncodingError.invalidDataFormat)
            }
        }
        
    }
    
    static func retrieveArticles(in page: Int, completionHandler: @escaping ([ArticleModel]?, Error?) -> Void) {
        
        let url = URL(string: NetworkingUrls.apiBlogArticlesUrl + String(page))
        
        let key = NSString(string: url!.absoluteString)
        
        let request = HttpRequest(url: url, method: .get)
        
        if let requestCache = cache.object(forKey: key) {
            do {
                let blog = try encodeBlog(requestCache, type: BlogModel.self)
                let articles = blog?.data
                completionHandler(articles, nil)
            } catch {
                completionHandler(nil, EncodingError.invalidDataFormat)
            }
            
            return
        }
        
        request.send { data, response, error in
            
            if let _ = error {
                completionHandler(nil,  error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(nil, StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let dataAsString = NSString(string: String(decoding: data,as: UTF8.self))
            
            do {
                let blog = try encodeBlog(dataAsString, type: BlogModel.self)
                let articles = blog?.data
                NetworkingManager.cache.setObject(dataAsString, forKey: key)
                
                completionHandler(articles, nil)
            } catch {
                completionHandler(nil, EncodingError.invalidDataFormat)
            }
        }
        
    }
    
    static func encodeBlog<T: Decodable>(_ data: NSString, type: T.Type)  throws -> T? {
        let stringToData = Data(String(data).utf8)
        let decoder = JSONDecoder()
        let blog = try decoder.decode(type.self, from: stringToData)
        return blog
    }
    
    static func retrieveVideos(in page: Int, completionHandler: @escaping ([VideoModel]?, Error?) -> Void) {
        
        let url = URL(string: NetworkingUrls.apiBlogVideosUrl + String(page))
        
        let key = NSString(string: url!.absoluteString)
        
        let request = HttpRequest(url: url, method: .get)
        
        if let requestCache = cache.object(forKey: key) {
            do {
                let blog = try encodeBlog(requestCache, type: VideosTopModel.self)
                let articles = blog?.data
                completionHandler(articles, nil)
            } catch {
                completionHandler(nil, EncodingError.invalidDataFormat)
            }
            
            return
        }
        
        request.send { data, response, error in
            
            if let _ = error {
                completionHandler(nil,  error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(nil, StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let dataAsString = NSString(string: String(decoding: data,as: UTF8.self))
            
            do {
                let blog = try encodeBlog(dataAsString, type: VideosTopModel.self)
                let articles = blog?.data
                NetworkingManager.cache.setObject(dataAsString, forKey: key)
                
                completionHandler(articles, nil)
            } catch {
                completionHandler(nil, EncodingError.invalidDataFormat)
            }
        }
    }
    
    static func getPrivacyPolicyAndAboutUs(of type: CallType, completionHandler: @escaping (PrivacyPolicyAndAboutUsModel?, Error?) -> Void) {
        
        var urlString = ""
        if type == .aboutUs {urlString = NetworkingUrls.apiAboutUs}
        else {urlString = NetworkingUrls.apiPrivacyPolicy}
        
        let url = URL(string: urlString)
        
        let request = HttpRequest(url: url, method: .get)
        
        request.send { data, response, error in
            
            if let _ = error {
                completionHandler(nil,  error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(nil, StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let dataAsString = NSString(string: String(decoding: data,as: UTF8.self))
            
            do {
                let privacyPolicyAndAboutUsModel = try encodeBlog(dataAsString, type: [PrivacyPolicyAndAboutUsModel].self)
                completionHandler(privacyPolicyAndAboutUsModel?.first, nil)
            } catch {
                print("invalid data format")
                completionHandler(nil, EncodingError.invalidDataFormat)
            }
        }
    }
    
    
    
    // @stub
    static func sendEmail(name: String, phoneNumber: String, messageContent: String) {
        
    }
    
    private static func parseDataIntoDictionary(data: Data) -> [String: Any]? {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        let dictionary = json as? [String: Any]
        
        return dictionary
    }
}
