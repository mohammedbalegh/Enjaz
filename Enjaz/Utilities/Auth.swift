import SwiftKeychainWrapper

struct Auth {
    enum unwrappingError: Error {
        case errorUnwrapping(value: String)
    }
    
    static var resetPassword = NetworkingManager.resetPassword
    static var requestEmailVerificationCode = NetworkingManager.requestEmailVerificationCode
    static var verifyEmail = NetworkingManager.verifyEmail
    static var accessToken: String? {
        get {
            return KeychainWrapper.standard.string(forKey: KeychainKeys.accessToken)
        }
    }
    
    static var userID: String? {
        get {
            return KeychainWrapper.standard.string(forKey: KeychainKeys.userId)
        }
    }
    
    static func signup(user: UserModel, password: String, completionHandler: @escaping (_ user: UserModel?, _ error: Error?) -> Void) {
        NetworkingManager.signUp(user: user, password: password) { (token, user, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let token = token, let user = user else {
                completionHandler(nil, unwrappingError.errorUnwrapping(value: "token or user"))
                return
            }
            
            guard let id = user["id"] as? Int, let username = user["username"] as? String, let name = user["full_name"] as? String, let email = user["email"] as? String else {
                completionHandler(nil, unwrappingError.errorUnwrapping(value: "user data"))
                return
            }
            
            saveAccessTokenAndUserIdToKeyChain(token, id)
            
            let newUser = UserModel(id: id, name: name, username: username, email: email, my_msg: "", my_view: "", about_me: "")
            
            completionHandler(newUser, nil)
        }
    }
    
    static func login(username: String, password: String, completionHandler: @escaping (_ user: UserModel?, _ error: Error?) -> Void) {
        NetworkingManager.logIn(username: username, password: password) { (token, user, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
                        
            guard let token = token, let user = user else {
                completionHandler(nil, unwrappingError.errorUnwrapping(value: "token and user"))
                return
            }
            
            guard let id = user["id"] as? Int, let username = user["username"] as? String, let name = user["full_name"] as? String, let email = user["email"] as? String else {
                completionHandler(nil, unwrappingError.errorUnwrapping(value: "user fields"))
                return
            }
            
            saveAccessTokenAndUserIdToKeyChain(token, id)
            
            // Save user to userDefaults
            let newUser = UserModel(id: id, name: name, username: username, email: email, my_msg: "", my_view: "", about_me: "")
            
            completionHandler(newUser, nil)
        }
    }
    
    static func signOut() {
        resetAccessTokenAndUserIdInKeyChain()
    }
    
    private static func saveAccessTokenAndUserIdToKeyChain(_ token: String, _ id: Int) {
        KeychainWrapper.standard.set(token, forKey: KeychainKeys.accessToken)
        KeychainWrapper.standard.set(id, forKey: KeychainKeys.userId)
    }
    
    private static func resetAccessTokenAndUserIdInKeyChain() {
        saveAccessTokenAndUserIdToKeyChain("", -1)
    }
}
