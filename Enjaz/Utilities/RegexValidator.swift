import Foundation

struct RegexValidator {
    
	static func validateUsername(candidate: String) -> Bool {
		let userName = "^\\w{7,18}$"
		return NSPredicate(format: "SELF MATCHES %@", userName).evaluate(with: candidate)
	}
	
	static func validateEmail(candidate: String) -> Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
	}
		
	static func validateResetCode(candidate: String) -> Bool {
		let passwordRegex = "^\\d{6}$"
		return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
	}
		
}
