import Foundation
import Firebase

class SearchService {
    static func searchUser(input: String, onSuccess: @escaping (_ user: [User]) -> Void) {
        AuthService.storeRoot.collection("users")
            .whereField("searchName", arrayContains: input.lowercased()
                            .removeWhiteSpace()).getDocuments { (querySnapshot, _) in
            guard let snap = querySnapshot else {return}
            var users = [User]()
            for document in snap.documents {
                let dict = document.data()
                guard let decoded = try? User.init(fromDictionary: dict) else {return}
                if decoded.uid != Auth.auth().currentUser!.uid {
                    users.append(decoded)
                }
                onSuccess(users)
            }
        }
    }
}
