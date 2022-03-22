import Foundation

extension BidirectionalCollection where Element: StringProtocol {
    func joinAsSentence() -> String {
        let comma = ",".localized + " "
        let and = " " + "and".localized + " "
        
        guard let last = last else { return "" }
        
        if count <= 2 {
            return joined(separator: and)
        }
        
        return dropLast().joined(separator: comma) + and + last
    }
}
