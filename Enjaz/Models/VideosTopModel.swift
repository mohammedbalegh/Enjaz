import Foundation

struct VideosTopModel: Decodable {
    let data: [VideoModel]
    let meta: MetaModel
}
