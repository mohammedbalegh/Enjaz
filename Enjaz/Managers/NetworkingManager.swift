import UIKit

struct NetworkingManager {
    enum StatusCodeError: Error {
        case statusCode(code: Int)
    }
    
    enum EncodingError: Error {
        case invalidDataFormat
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
    
    static func retreiveItemImages(completionHandler: @escaping (_ images: [ItemImageModel?]?, _ error: Error?) -> Void) {
        let url = URL(string: NetworkingUrls.itemImagesUrl)
        
        let request = HttpRequest(url: url, method: .get)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler(nil, StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            guard let data = data else {
                completionHandler(nil, EncodingError.invalidDataFormat)
                return
            }
            
            do {
                var index = 0
                let itemImages = try JSONDecoder().decode([ItemImageModel].self, from: data).map() { itemImage -> ItemImageModel in
                    let defaultItemImage = itemImage
                    defaultItemImage.is_default = true
                    defaultItemImage.id = index
                    index += 1
                    return defaultItemImage
                }
                completionHandler(itemImages, nil)
            } catch {
                print("encoding error")
                completionHandler(nil, EncodingError.invalidDataFormat)
            }
            
        }
    }
    
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
    
    static func retrieveMedals() {
        
        let url = URL(string: NetworkingUrls.apiMedals)
        
        let request = HttpRequest(url: url, method: .get)
        
        request.send { data, response, error in
            
            if let _ = error {
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299) ~= response.statusCode else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            let dataAsString = NSString(string: String(decoding: data,as: UTF8.self))
            
            do {
                let medals = try encodeBlog(dataAsString, type: [MedalModel].self)
                
                RealmManager.saveItemMedal(medals!)
            } catch {
                return
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
            // TODO: fix the decoding problem in the articles and videos retreval. eg. the following code block fails
            do {
                let blog = try JSONDecoder().decode(BlogModel.self, from: data)
                let articles = blog.data
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
                let blog = try JSONDecoder().decode(VideosTopModel.self, from: data)
                let videos = blog.data
                NetworkingManager.cache.setObject(dataAsString, forKey: key)
                
                completionHandler(videos, nil)
            } catch {
                completionHandler(nil, EncodingError.invalidDataFormat)
            }
        }
    }
    
    static func retrievePrivacyPolicy(completionHandler: @escaping (PrivacyPolicyAndAboutUsModel?, Error?) -> Void) {
        let url = URL(string: NetworkingUrls.apiPrivacyPolicy)
		retrievePrivacyPolicyAndAboutUs(url: url, completionHandler: completionHandler)
    }
    
    static func retrieveAboutUs(completionHandler: @escaping (PrivacyPolicyAndAboutUsModel?, Error?) -> Void) {
        let url = URL(string: NetworkingUrls.apiPrivacyPolicy)
        retrievePrivacyPolicyAndAboutUs(url: url, completionHandler: completionHandler)
    }
    
    private static func retrievePrivacyPolicyAndAboutUs(url: URL?, completionHandler: @escaping (PrivacyPolicyAndAboutUsModel?, Error?) -> Void) {
        let request = HttpRequest(url: url, method: .get)
        
        request.send { data, response, error in
            
            if let error = error {
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
            
            let dataAsString = NSString(string: String(decoding: data, as: UTF8.self))
            print(dataAsString)
            
            do {
                let privacyPolicyAndAboutUsModel = try JSONDecoder().decode(PrivacyPolicyAndAboutUsModel.self, from: data)
                completionHandler(privacyPolicyAndAboutUsModel, nil)
            } catch {
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
