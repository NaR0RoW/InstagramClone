import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        
        VStack {
            
            Text("Home View")
            
            Button(action: session.logout) {
                
                Text("Log Out")
                    .font(.title)
                    .modifier(ButtonModifiers())
            }
        }
    }
}
