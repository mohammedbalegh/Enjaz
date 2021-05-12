import Foundation

struct ArticleModel: Decodable {
    let title: String
    let article: String
    let image: String
    let category: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case article = "article_title"
        case image
        case category
        case date
    }
}
