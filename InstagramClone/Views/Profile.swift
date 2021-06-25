import FirebaseAuth
import SDWebImageSwiftUI
import SwiftUI

struct Profile: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var profileService = ProfieleService()
    @State private var selection: Int = 1
    let threeColumns = [GridItem(), GridItem(), GridItem()]
    var body: some View {
        ScrollView {
            VStack {
                ProfileHeader(user: self.session.session, postsCount: profileService.posts.count,
                              following: $profileService.following, followers: $profileService.followers)
                Button(action: {}) {
                    Text("Edit Profile")
                        .font(.title)
                        .modifier(ButtonModifiers())
                }
                .padding(.horizontal)
                Picker("", selection: $selection) {
                    Image(systemName: "circle.grid.2x2.fill")
                        .tag(0)
                    Image(systemName: "person.circle")
                        .tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                if selection == 0 {
                    LazyVGrid(columns: threeColumns) {
                        ForEach(self.profileService.posts, id: \.postId) { (post) in
                            WebImage(url: URL(string: post.mediaUrl)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 3)
                                .clipped()
                        }
                    }
                } else if self.session.session == nil {Text("")} else {
                    ScrollView {
                        VStack {
                            ForEach(self.profileService.posts, id: \.postId) { (post) in
                                PostCardImage(post: post)
                                PostCard(post: post)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
        }) {
            NavigationLink(destination: UserProfile()) {
            Image(systemName: "person.fill")
            }
        }, trailing: Button(action: {
            self.session.logout()
        }) {
            Image(systemName: "arrow.right.circle.fill")
        })
        .onAppear {
            self.profileService.loadUserPosts(userId: Auth.auth().currentUser!.uid)
        }
    }
}
