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
            // MARK: Good force unwrapp?
            if Auth.auth().currentUser?.uid != nil {
                self.profileService.loadUserPosts(userId: Auth.auth().currentUser!.uid)
            } else {return}
        }
    }
}
