import Foundation

struct ArticleModel: Decodable {
    let title: String
    let articleTitle: String
    let image: String
    let category: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case articleTitle = "article_title"
        case image
        case category
        case date
    }
}
