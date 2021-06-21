import SwiftUI

struct SignInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 20) {
                
                Image(systemName: "camera")
                    .font(.system(size: 60, weight: .black, design: .monospaced))
                
                VStack(alignment: .leading) {
                    
                    Text("Welcome Back")
                        .font(.system(size: 32, weight: .heavy))
                    
                    Text("SignIn To Continue")
                        .font(.system(size: 16, weight: .medium))
                }
                
                FormField(value: $email, icon: "envelope.fill", placeholder: "E-mail")
                
                FormField(value: $password, icon: "lock.fill", isSecure: true, placeholder: "Password")
                
                Button(action: {}) {
                    
                    Text("Sign In")
                        .font(.title)
                        .modifier(ButtonModifiers())
                }
                
                HStack {
                    
                    Text("New?")
                    
                    NavigationLink(destination: SignUpView()) {
                        
                        Text("Create an Account.")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
        }
    }
}
