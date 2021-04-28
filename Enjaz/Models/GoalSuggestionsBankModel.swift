import Foundation

struct GoalSuggestionsBankModel: Codable {
    let data: [GoalSuggestionsModel]
}

struct GoalSuggestionsModel: Codable {
    let id: Int
    let text: String
    let image: String
}
