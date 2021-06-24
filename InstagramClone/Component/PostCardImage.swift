import SwiftUI
import SDWebImageSwiftUI

struct PostCardImage: View {
    var post: PostModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                WebImage(url: URL(string: post.profile)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60, alignment: .center)
                    .shadow(color: .gray, radius: 3)
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.username)
                        .font(.headline)
                    Text((Date(timeIntervalSince1970: post.date))
                        .timeAgo() + " ago")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10)
            }
            .padding(.leading)
            .padding(.top, 16)
            Text(post.caption)
                .lineLimit(nil)
                .padding(.leading, 16)
                .padding(.trailing, 32)
            WebImage(url: URL(string: post.mediaUrl)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.size.width, height: 400, alignment: .center)
                .clipped()
        }
    }
}
