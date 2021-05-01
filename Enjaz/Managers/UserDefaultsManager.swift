import UIKit

struct UserDefaultsManager {
    struct Keys {
        static let user = "user"
        static let isLoggedIn = "isLoggedIn"
        static let majorGoals = "majorGoals"
		static let interFaceStyle = "interFaceStyleID"
        static let aboutUs = "aboutUs"
        static let privacyPolicy = "privacyPolicy"
        static let goalsBank = "goalsBank"
    }
    
    static var goalsBank: [GoalSuggestionsModel]? {
        get {
            guard let userData = UserDefaults.standard.data(forKey: Keys.goalsBank) else { return nil }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode([GoalSuggestionsModel].self, from: userData)
                return user
            } catch {
                print("Unable to Decode data (\(error))")
                return nil
            }
        }
        
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.set(nil, forKey: Keys.goalsBank)
                UserDefaults.standard.synchronize()
                return
            }
            
            do {
                let encoder = JSONEncoder()
                let userData = try encoder.encode(newValue)
                UserDefaults.standard.set(userData, forKey: Keys.goalsBank)
                UserDefaults.standard.synchronize()
            } catch {
                print("Unable to Encode data (\(error))")
            }
        }
    }
    
    static var aboutUs: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.aboutUs)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.aboutUs)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var privacyPolicy: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.privacyPolicy)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.privacyPolicy)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isLoggedIn)
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
                print("Unable to Decode data (\(error))")
                return nil
            }
        }
        
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.set(nil, forKey: Keys.user)
                UserDefaults.standard.synchronize()
                return
            }
            
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

    var majorGoals: [String]? {
        get {
            return UserDefaults.standard.array(forKey: Keys.majorGoals) as? [String]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.majorGoals)
            UserDefaults.standard.synchronize()
        }
    }
	
	static var interfaceStyleId: Int? {
		get {
			return UserDefaults.standard.integer(forKey: Keys.interFaceStyle)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: Keys.interFaceStyle)
			UserDefaults.standard.synchronize()
		}
	}
    
}
