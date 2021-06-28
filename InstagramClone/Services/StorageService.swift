import Foundation
import Firebase

class StorageService {
    static var storage = Storage.storage()
    static var storageRoot = storage.reference(forURL: "gs://instagramclone-c4365.appspot.com")
    static var storageProfile = storageRoot.child("profile")
    static var storagePost = storageRoot.child("posts")
    static var storageChat = storageRoot.child("chat")
    static func storagePostId(postId: String) -> StorageReference {
        return storagePost.child(postId)
    }
    static func storageProfileId(userId: String) -> StorageReference {
        return storageProfile.child(userId)
    }
    static func storageChatId(chatId: String) -> StorageReference {
        return storageChat.child(chatId)
    }
    static func saveProfileImage(userId: String, username: String, email: String,
                                 imageData: Data, metaData: StorageMetadata, storageProfileImageRef: StorageReference,
                                 onSuccess: @escaping(_ user: User) -> Void,
                                 onError: @escaping(_ errorMessage: String) -> Void ) {
        storageProfileImageRef.putData(imageData, metadata: metaData) { (_, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            storageProfileImageRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges { (error) in
                            if error != nil {
                                onError(error!.localizedDescription)
                                return
                            }
                        }
                    }
                    let firestoreUserId = AuthService.getUserId(userId: userId)
                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl,
                                         username: username, searchName: username.splitString(), bio: "")
                    guard let dict = try? user.asDisctionary() else {return}
                    firestoreUserId.setData(dict) { (error) in
                        if error != nil {
                            onError(error!.localizedDescription)
                            return
                        }
                    }
                    onSuccess(user)
                }
            }
        }
    }
    static func savePostPhoto(userId: String, caption: String, postId: String,
                              imageData: Data, metadata: StorageMetadata, storagePostRef: StorageReference,
                              onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        storagePostRef.putData(imageData, metadata: metadata) { (_, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            storagePostRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    let firestorePostRef = PostService.postsUserId(userId: userId)
                        .collection("posts").document(postId)
                    let post = PostModel.init(caption: caption, likes: [:], geoLocation: "", ownerId: userId,
                                              postId: postId, username: Auth.auth().currentUser!.displayName!,
                                              profile: Auth.auth().currentUser!.photoURL!.absoluteString,
                                              mediaUrl: metaImageUrl,
                                              date: Date().timeIntervalSince1970, likeCount: 0)
                    guard let dict = try? post.asDisctionary() else {return}
                    firestorePostRef.setData(dict) { (error) in
                        if error != nil {
                            onError(error!.localizedDescription)
                            return
                        }
                        PostService.timelineUserId(userId: userId).collection("timeline")
                            .document(postId).setData(dict)
                        PostService.AllPosts.document(postId).setData(dict)
                        onSuccess()
                    }
                }
            }
        }
    }
    static func editProfile(userId: String, username: String,
                            bio: String, imageData: Data, metaData: StorageMetadata,
                            storageProfileImageRef: StorageReference,
                            onError: @escaping(_ errorMessage: String) -> Void) {
        storageProfileImageRef.putData(imageData, metadata: metaData) { (_, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            storageProfileImageRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges { (error) in
                            if error != nil {
                                onError(error!.localizedDescription)
                                return
                            }
                        }
                    }
                    let firestoreUserId = AuthService.getUserId(userId: userId)
                    firestoreUserId.updateData([
                        "profileImageUrl": metaImageUrl,
                        "username": username,
                        "bio": bio
                    ])
                }
            }
        }
    }
    static func saveChatPhoto(messageId: String, recipientId: String,
                              recipientProfile: String, recipientName: String,
                              senderId: String, senderUsername: String,
                              senderProfile: String,
                              imageData: Data, metadata: StorageMetadata,
                              storageChatRef: StorageReference,
                              onSuccess: @escaping() -> Void,
                              onError: @escaping(_ error: String) -> Void) {
        storageChatRef.putData(imageData, metadata: metadata) { (_, err) in
            if err != nil {
                onError(err!.localizedDescription)
                return
            }
            storageChatRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    let chat = Chat(messageId: messageId, textMessage: "",
                                    profile: senderProfile,
                                    photoUrl: metaImageUrl, sender: senderId, username: senderUsername,
                                    timestamp: Date().timeIntervalSince1970, isPhoto: true)
                    guard let dict = try? chat.asDisctionary() else {return}
                    ChatService.conversation(sender: senderId, recipient: recipientId)
                        .document(messageId).setData(dict) { (error) in
                        if error == nil {
                            ChatService.conversation(sender: recipientId, recipient: senderId)
                                .document(messageId).setData(dict)
                            let senderMessage = Message(lastMessage: "", username: senderUsername,
                                                        isPhoto: true, timestamp: Date().timeIntervalSince1970,
                                                        userId: senderId, profile: senderProfile)
                            let recipientMessage = Message(lastMessage: "", username: recipientName,
                                                           isPhoto: false, timestamp: Date().timeIntervalSince1970,
                                                           userId: recipientId, profile: recipientProfile)
                            guard let senderDict = try? senderMessage.asDisctionary() else {return}
                            guard let recipientDict = try? recipientMessage.asDisctionary() else {return}
                            ChatService.messagesId(senderId: senderId, recipientId: recipientId).setData(senderDict)
                            ChatService.messagesId(senderId: recipientId, recipientId: senderId).setData(recipientDict)
                            onSuccess()
                        } else {
                            onError(error!.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
