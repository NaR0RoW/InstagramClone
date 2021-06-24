import SwiftUI
import SDWebImageSwiftUI

struct ProfileHeader: View {
    var user: User?
    var body: some View {
        HStack {
            VStack {
                if user != nil {
                    WebImage(url: URL(string: user!.profileImageUrl)!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .trailing)
                        .padding(.leading)
                } else {
                    Color.init(red: 0.9, green: 0.9, blue: 0.9)
                        .frame(width: 100, height: 100, alignment: .trailing)
                        .padding(.leading)
                }
                Text(user!.username)
                    .font(.headline)
                    .bold()
                    .padding(.leading)
            }
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("Followers")
                            .font(.headline)
                        Text("20")
                            .font(.title)
                            .bold()
                    }
                    .padding(.top, 60)
                    Spacer()
                    VStack {
                        Text("Following")
                            .font(.headline)
                        Text("20")
                            .font(.title)
                            .bold()
                    }
                    .padding(.top, 60)
                    Spacer()
                }
            }
        }
    }
}
