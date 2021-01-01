import Foundation

class NetworkingManager {
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
        
        let request = Request(url: url, method: .post, data: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(nil, nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            
            guard (200 ... 299) ~= response.statusCode else {
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
        
        let request = Request(url: url, method: .post, data: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(nil, nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            
            guard (200 ... 299) ~= response.statusCode else {
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
        
        let request = Request(url: url, method: .post, data: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200 ... 299) ~= response.statusCode else {
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
        
        let request = Request(url: url, method: .post, data: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200 ... 299) ~= response.statusCode else {
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
        
        let request = Request(url: url, method: .post, data: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200 ... 299) ~= response.statusCode else {
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
        
        let request = Request(url: url, method: .post, data: data)
        
        request.send { (data, response, error) in
            if let error = error {
                completionHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200 ... 299) ~= response.statusCode else {
                completionHandler(StatusCodeError.statusCode(code: response.statusCode))
                return
            }
            
            completionHandler(nil)
        }
    }
    
    // @stub
    static func retrieveGoalSuggestions(completionHandler: (_ goalSuggestions: [String]) -> Void){
    
        let goalSuggestions = ["الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي","الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي","الحصول علي 97% في دراستي","المداومة علي الركض صباحا","قراءة كتاب عن احد الفنون","زيارة ذوي القربي","المداومة علي اذكار الصباح و المساء","تلاوة 5 صفحات من القرآن يوميا"]
        
        completionHandler(goalSuggestions)
    }
        
    private static func parseDataIntoDictionary(data: Data) -> [String: Any]? {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        let dictionary = json as? [String: Any]
        
        return dictionary
    }
}
