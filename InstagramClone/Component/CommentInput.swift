import SwiftUI
import SDWebImageSwiftUI

// All is fine
struct CommentInput: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var commentService = CommentService()
    @State private var text: String = ""
    init(post: PostModel?, postId: String?) {
        if post != nil {
            commentService.post = post
        } else {
            handleInput(postId: postId!)
        }
    }
    func handleInput(postId: String) {
        PostService.loadPost(postId: postId) { (post) in
            self.commentService.post = post
        }
    }
    func sendComment() {
        if !text.isEmpty {
            commentService.addComment(comment: text) {
                self.text = ""
            }
        }
    }
    var body: some View {
        HStack {
            WebImage(url: URL(string: session.session!.profileImageUrl)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 50, height: 50, alignment: .center)
                .shadow(color: .gray, radius: 3)
                .padding(.leading)
            HStack {
                TextEditor(text: $text)
                    .frame(height: 50)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 8, style: .circular).stroke(Color.black, lineWidth: 2))
                Button(action: sendComment) {
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                        .padding(.trailing)
                }
            }
        }
    }
}
