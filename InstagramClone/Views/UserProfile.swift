import SwiftUI
import SDWebImageSwiftUI

struct UserProfile: View {
    @State private var value: String = ""
    @State var users: [User] = []
    @State var isLoading: Bool = false
    func searchUsers() {
        isLoading = true
        SearchService.searchUser(input: value) { (users) in
            self.isLoading = false
            self.users = users
        }
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                SearchBar(value: $value)
                    .padding()
                    .onChange(of: value, perform: { _ in
                        searchUsers()
                    })
                if !isLoading {
                    ForEach(users, id: \.uid) { user in
                        HStack {
                            WebImage(url: URL(string: user.profileImageUrl)!)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 60, height: 60, alignment: .trailing)
                                .padding()
                            Text(user.username)
                                .font(.subheadline)
                                .bold()
                        }
                        Divider()
                            .background(Color.black)
                    }
                }
            }
        }
        .navigationTitle("User Search")
    }
}
