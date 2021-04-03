import Foundation

enum ItemType {
    case goal
    case demah
    case achievement
    case task
    
    var name: String {
        switch self {
        case .goal:
            return NSLocalizedString("Goal", comment: "")
        case .demah:
            return NSLocalizedString("Demah", comment: "")
        case .achievement:
            return NSLocalizedString("Achievement", comment: "")
        case .task:
            return NSLocalizedString("Task", comment: "")
        }
    }
    
    var id: Int {
        switch self {
        case .goal:
            return 0
        case .demah:
            return 1
        case .achievement:
            return 2
        case .task:
            return 3
        }
    }
    
    static func getTypeById(id: Int) -> ItemType {
        switch id {
        case 0:
            return ItemType.goal
        case 1:
            return ItemType.demah
        case 2:
            return ItemType.achievement
        case 3:
            return ItemType.task
        default:
            fatalError("Invalid item id")
        }
    }
}