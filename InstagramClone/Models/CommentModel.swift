import Foundation

struct CommentModel: Encodable, Decodable, Identifiable {
    var id = UUID()
    var profile: String
    var postId: String
    var username: String
    var data: Double
    var comment: String
    var ownerId: String
}
