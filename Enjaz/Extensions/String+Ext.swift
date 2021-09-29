import UIKit

extension String {
    
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
	
    var isURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        }
        
        return false
    }
    
    var isPhoneNumber: Bool {
        if self.isAllDigits() {
            let phoneRegex = "[0-9]{6,14}"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return  predicate.evaluate(with: self)
        }
        
        return false
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(
            uncheckedBounds: (lower: max(0, min(count, r.lowerBound)), upper: min(count, max(0, r.upperBound)))
        )
        
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    static func isOrAre(count: Int) -> String {
        return count > 1 ? "are" : "is"
    }
    
    static func generateRequiredFieldNamesErrorMessage(requiredFieldNames: [String]?) -> String? {
        guard let requiredFieldNames = requiredFieldNames, !requiredFieldNames.isEmpty else { return nil }
        
        let requiredFieldNamesAsSentence = requiredFieldNames.joinAsSentence()
        let numberOfNonProvidedRequiredFields = requiredFieldNames.count
        
        if Locale.current.languageCode == "ar" {
            return "يجب ادخال \(requiredFieldNamesAsSentence)."
        }
        
        return "\(requiredFieldNamesAsSentence) field\(numberOfNonProvidedRequiredFields > 1 ? "s" : "") \(String.isOrAre(count: numberOfNonProvidedRequiredFields)) required.".capitalizeOnlyFirstLetter()
    }
    
    private func isAllDigits()->Bool {
        let characterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: characterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    
    func substring(fromIndex startingIndex: Int) -> String {
        return self[min(startingIndex, count) ..< count]
    }
    
    func substring(toIndex endingIndex: Int) -> String {
        return self[0 ..< max(0, endingIndex)]
    }
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func capitalizeOnlyFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst().lowercased()
    }
        
    func attributedStringWithColor(_ subStrings: [String], color: UIColor, stringSize size: CGFloat = 16, coloredSubstringsSize: CGFloat = 16) -> NSAttributedString {
        let font: UIFont = .systemFont(ofSize: size)
        let attributedString = NSMutableAttributedString(string: self, attributes: [.font : font])
        
        for subString in subStrings {
            let range = (self as NSString).range(of: subString)
            let subStringFont: UIFont = .systemFont(ofSize: coloredSubstringsSize)
            attributedString.addAttributes([.foregroundColor: color, .font: subStringFont], range: range)
        }
        
        return attributedString
    }
	
	func attributedStringWithImage(_ image: UIImage?, color: UIColor? = nil) -> NSAttributedString {
		let attributedString = NSAttributedString(string: " \(self)")
		
		let imageAttachment = NSTextAttachment()
		imageAttachment.image = image
		
		let imageString = NSMutableAttributedString(attachment: imageAttachment)
		
		imageString.append(attributedString)
		
		return imageString
	}
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
	
	func pluralizeInEnglishBasedOn(count: Int) -> String {
		return count > 1 ? self + "s" : self
	}
	
	func pluralizeInEnglish() -> String {
		return self + "s"
	}
	
	func removeDefinitionArticle() -> String {
		return self.replacingOccurrences(of: "the", with: "").replacingOccurrences(of: "ال", with: "")
	}
}
