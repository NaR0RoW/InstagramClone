import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct EditProfile: View {
    @EnvironmentObject var session: SessionStore
    @State private var username: String = ""
    @State private var profileImage: Image?
    @State private var pickedImage: Image?
    @State private var showingActionSheet: Bool = false
    @State private var showingImagePicker: Bool = false
    @State private var imageData: Data = Data()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var error: String = ""
    @State private var showingAlert: Bool = false
    @State private var alertTitle: String = "On No 😭"
    @State private var bio: String = ""
    init(session: User?) {
        _bio = State(initialValue: session?.bio ?? "")
        _username = State(initialValue: session?.username ?? "")
    }
    func loadImage() {
        guard let inputImage = pickedImage else {return}
        profileImage = inputImage
    }
    func errorCheck() -> String? {
        if username.trimmingCharacters(in: .whitespaces).isEmpty ||
            bio.trimmingCharacters(in: .whitespaces).isEmpty || imageData.isEmpty {
            return "Please fill in all fields and provide an image"
        }
        return nil
    }
    func clear() {
        self.bio = ""
        self.username = ""
        self.imageData = Data()
        self.profileImage = Image(systemName: "person.circle.fill")
    }
    func edit() {
        if let error = errorCheck() {
            self.error = error
            self.showingAlert = true
            return
        }
        guard let userId = Auth.auth().currentUser?.uid else {return}
        let storageProfileUserId = StorageService.storageProfileId(userId: userId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        StorageService.editProfile(userId: userId, username: username,
                                   bio: bio, imageData: imageData,
                                   metaData: metadata,
                                   storageProfileImageRef: storageProfileUserId,
                                   onError: { (errorMessage) in
            self.error = errorMessage
            self.showingAlert = true
            return
        })
        self.clear()
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Edit Profile")
                    .font(.largeTitle)
                VStack {
                    Group {
                        if profileImage != nil {
                            profileImage!
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 200, height: 200)
                                .padding(.top, 20)
                                .onTapGesture {
                                    self.showingActionSheet = true
                                }
                        } else {
                            WebImage(url: URL(string: session.session!.profileImageUrl)!)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                                .padding(.top, 20)
                                .onTapGesture {
                                    self.showingActionSheet = true
                                }
                        }
                    }
                }
                FormField(value: $username, icon: "person.fill", placeholder: "Username")
                FormField(value: $bio, icon: "book.fill", placeholder: "Bio")
                Button(action: edit) {
                    Text("Edit")
                        .font(.title)
                        .modifier(ButtonModifiers())
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
                }
                Text("Changes will be effected next time you log in")
            }
        }
        .navigationTitle(session.session!.username)
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(pickedImage: self.$pickedImage,
                        showImagePicker: self.$showingImagePicker, imageData: self.$imageData)
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(""), buttons: [.default(Text("Choose A Photo")) {
                self.sourceType = .photoLibrary
                self.showingImagePicker = true
            },
            .default(Text("Take A Photo")) {
                self.sourceType = .camera
                self.showingImagePicker = true
            },
            .cancel()
            ])
        }
    }
}
