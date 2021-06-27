import SwiftUI
import FirebaseAuth

struct Main: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var profileService = ProfileService()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.profileService.posts, id: \.postId) { (post) in
                    PostCardImage(post: post)
                    PostCard(post: post)
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            // bad force unwrap
            self.profileService.loadUserPosts(userId: Auth.auth().currentUser!.uid )
        }
    }
}
