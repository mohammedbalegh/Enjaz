import UIKit

struct VideoModel: Decodable {
	let thumbnail: String = "tempArticleThumbnail"
    let title, articleTitle: String
    let url: String
    let category, date: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case articleTitle = "article_title"
        case url = "video"
		case category, date
    }
}
