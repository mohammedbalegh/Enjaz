import UIKit

struct NetworkingManager {
    enum StatusCodeError: Error {
        case statusCode(code: Int)
    }
    
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
    static func retrieveGoalSuggestions(completionHandler: (_ goalSuggestions: [String]) -> Void) {
        let goalSuggestions = ["الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي","الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي","الحصول علي 97% في دراستي","المداومة علي الركض صباحا","قراءة كتاب عن احد الفنون","زيارة ذوي القربي","المداومة علي اذكار الصباح و المساء","تلاوة 5 صفحات من القرآن يوميا"]
        
        completionHandler(goalSuggestions)
    }
    
    // @stub
    static func retrieveArticles(completionHandler: (_ articles: [ArticleModel]) -> Void) {
        let image = UIImage(named: "tempArticleThumbnail")
        let header = UIImage(named: "tempArticleHeader")
        
        let articles = [
            ArticleModel(thumbnail: image, header: header, category: "Religious", title: "Article Title", date: Date(), article: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
            ArticleModel(thumbnail: image, header: header, category: "Religious", title: "Article Title", date: Date(), article: ""),
            ArticleModel(thumbnail: image, header: header, category: "Religious", title: "Article Title", date: Date(), article: ""),
        ]
        
        completionHandler(articles)
    }
    
    // @stub
    static func retrieveVideos(completionHandler: (_ videos: [VideoModel]) -> Void) {
        let image = UIImage(named: "tempArticleThumbnail")
        
        let videos = [
            VideoModel(thumbnail: image, category: "Religious", title: "Video Title", date: Date(), videoUrl: ""),
            VideoModel(thumbnail: image, category: "Religious", title: "Video Title", date: Date(), videoUrl: ""),
            VideoModel(thumbnail: image, category: "Religious", title: "Video Title", date: Date(), videoUrl: ""),
        ]
        
        completionHandler(videos)
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
