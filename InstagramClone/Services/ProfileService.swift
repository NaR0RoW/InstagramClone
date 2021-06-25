import Foundation
import Firebase

class ProfieleService: ObservableObject {
    @Published var posts: [PostModel] = []
    @Published var following = 0
    @Published var followers = 0
    static var following = AuthService.storeRoot.collection("following")
    static var followers = AuthService.storeRoot.collection("followers")
    static func followingCollection(userid: String) -> CollectionReference {
        return following.document(userid).collection("following")
    }
    static func followersCollection(userid: String) -> CollectionReference {
        return followers.document(userid).collection("followers")
    }
    func loadUserPosts(userId: String) {
        PostService.loadUserPosts(userId: userId) { (posts) in
            self.posts = posts
        }
        followers(userId: userId)
        followers(userId: userId)
    }
    func follows(userId: String) {
        ProfieleService.followingCollection(userid: userId).getDocuments { (querysnapshot, _) in
            if let doc = querysnapshot?.documents {
                self.following = doc.count
            }
        }
    }
    func followers(userId: String) {
        ProfieleService.followersCollection(userid: userId).getDocuments { (querysnapshot, _) in
            if let doc = querysnapshot?.documents {
                self.followers = doc.count
            }
        }
    }
}
