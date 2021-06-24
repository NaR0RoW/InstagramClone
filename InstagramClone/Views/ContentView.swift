import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var session: SessionStore
    
    func listen() {
        session.listen()
    }
    
    var body: some View {
        Group {
            if (session.session != nil) {
                HomeView()
            } else {
                SignInView()
            }
        }
        .onAppear(perform: listen)
    }
}
