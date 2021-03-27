import Foundation

extension String {
	
	var test: Int {
		return 5
	}
    
    var isURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
	
	subscript (i: Int) -> String {
		return self[i ..< i + 1]
	}
	
	func substring(fromIndex: Int) -> String {
		return self[min(fromIndex, count) ..< count]
	}
	
	func substring(toIndex: Int) -> String {
		return self[0 ..< max(0, toIndex)]
	}
	
	subscript (r: Range<Int>) -> String {
		let range = Range(
			uncheckedBounds: (lower: max(0, min(count, r.lowerBound)), upper: min(count, max(0, r.upperBound)))
		)

		let start = index(startIndex, offsetBy: range.lowerBound)
		let end = index(start, offsetBy: range.upperBound - range.lowerBound)
		return String(self[start ..< end])
	}
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func capitalizeOnlyFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst().lowercased()
    }
    
    static func isOrAre(count: Int) -> String {
        return count > 1 ? "are" : "is"
    }
}
