import Foundation

struct MetaModel: Decodable {
    let currentPage: Int
    let from: Int
    let lastPage: Int
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
    }
}
