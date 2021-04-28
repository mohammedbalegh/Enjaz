import Foundation

struct BlogModel: Decodable {
    let data: [ArticleModel]
    let meta: MetaModel
}
