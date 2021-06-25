import SwiftUI
import FirebaseAuth

struct Main: View {
    var body: some View {
        Text("Main")
    }
}

//@EnvironmentObject var session: SessionStore
//@StateObject var profileService = ProfieleService()
//var body: some View {
//    ScrollView {
//        VStack {
//            ForEach(self.profileService.posts, id: \.postId) { (post) in
//                PostCardImage(post: post)
//                PostCard(post: post)
//            }
//        }
//    }
//    .navigationTitle("")
//    .navigationBarHidden(true)
//    .onAppear {
//        self.profileService.loadUserPosts(userId: Auth.auth().currentUser!.uid)
//    }
//}
