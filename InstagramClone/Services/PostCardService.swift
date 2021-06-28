import Foundation
import Firebase

class PostCardService: ObservableObject {
    @Published var post: PostModel!
    @Published var isLiked: Bool = false
    func hasLikedPost() {
        // MARK: Good force unwrapp?
        if Auth.auth().currentUser?.uid != nil {
            isLiked = (post.likes["\(Auth.auth().currentUser!.uid)"] == true) ? true: false
        } else {return}
    }
    func like() {
        post.likeCount += 1
        isLiked = true
        PostService.postsUserId(userId: post.ownerId).collection("posts")
            .document(post.postId)
            .updateData(["likeCount": post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": true])
        PostService.AllPosts.document(post.postId)
            .updateData(["likeCount": post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": true])
        PostService.timelineUserId(userId: post.ownerId).collection("timeline")
            .document(post.postId)
            .updateData(["likeCount": post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": true])
    }
    func unlike() {
        post.likeCount -= 1
        isLiked = false
        PostService.postsUserId(userId: post.ownerId).collection("posts")
            .document(post.postId)
            .updateData(["likeCount": post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": false])
        PostService.AllPosts.document(post.postId).updateData(["likeCount": post.likeCount,
                                                               "likes.\(Auth.auth().currentUser!.uid)": false])
        PostService.timelineUserId(userId: post.ownerId).collection("timeline")
            .document(post.postId)
            .updateData(["likeCount": post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": false])
    }
}
