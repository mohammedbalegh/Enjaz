import Foundation

struct UserDefaultsManager {
    struct Keys {
        static let user = "user"
        static let isLoggedIn = "isLoggedIn"
    }
    
    static var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
        }
        set {
            UserDefaults.standard.set(true, forKey: Keys.isLoggedIn)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var user: UserModel? {
        get {
            guard let userData = UserDefaults.standard.data(forKey: Keys.user) else { return nil }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserModel.self, from: userData)
                return user
            } catch {
                print("Unable to Decode Note (\(error))")
                return nil
            }
        }
        
        set {
            do {
                let encoder = JSONEncoder()
                let userData = try encoder.encode(newValue)
                UserDefaults.standard.set(userData, forKey: Keys.user)
                UserDefaults.standard.synchronize()
            } catch {
                print("Unable to Encode data (\(error))")
            }
        }
    }
    
}
