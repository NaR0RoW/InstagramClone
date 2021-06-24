import Foundation

class ProfieleService: ObservableObject {
    @Published var posts: [PostModel] = []
    func loadUserPosts(userId: String) {
        PostService.loadUserPosts(userId: userId) { (posts) in
            self.posts = posts
        }
    }
}
