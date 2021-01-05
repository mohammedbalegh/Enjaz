import Foundation

struct UserDefaultsManager {
    
    struct Keys {
        static let majorGoals = "majorGoals"
    }
    
    var majorGoals: [String]? {
        get {
            return UserDefaults.standard.array(forKey: Keys.majorGoals) as? [String]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.majorGoals)
        }
    }
    
    static func setUser(user: UserModel) {
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            UserDefaults.standard.set(userData, forKey: UserDefaultsKeys.user)
            UserDefaults.standard.synchronize()
        } catch {
            print("Unable to Encode data (\(error))")
        }
    }
    
    static func getUser() -> UserModel? {
        guard let userData = UserDefaults.standard.data(forKey: UserDefaultsKeys.user) else { return nil }
        
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(UserModel.self, from: userData)
            return user
        } catch {
            print("Unable to Decode Note (\(error))")
            return nil
        }
    }
}
