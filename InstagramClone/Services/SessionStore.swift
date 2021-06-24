import Foundation
import Combine
import Firebase

class SessionStore: ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    @Published var session: User? { didSet { self.didChange.send(self) }}
    func listen() {
        handle = Auth.auth().addStateDidChangeListener({ (_, user) in
            if let user = user {
                let firestoreUserId = AuthService.getUserId(userId: user.uid)
                firestoreUserId.getDocument { (document, _) in
                    if let dict = document?.data() {
                        guard let decodedUser = try? User.init(fromDictionary: dict) else {return}
                        self.session = decodedUser
                    }
                }
            } else {
                self.session = nil
            }
        })
    }
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
        }
    }
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    deinit {
        unbind()
    }
}
