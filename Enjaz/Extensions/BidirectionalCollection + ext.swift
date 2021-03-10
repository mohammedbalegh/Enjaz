import Foundation

extension BidirectionalCollection where Element: StringProtocol {
    func joinAsSentence(languageIsArabic: Bool) -> String {
        let comma = NSLocalizedString(",", comment: "") + " "
        let and = " " + NSLocalizedString("and", comment: "") + " "
        
        guard let last = last else { return "" }
        
        if count <= 2 {
            return joined(separator: and)
        }
        
        return dropLast().joined(separator: comma) + and + last
    }
}
