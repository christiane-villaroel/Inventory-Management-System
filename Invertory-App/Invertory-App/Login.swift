import SwiftUI

struct Login: View
{
    @State private var username = ""
    @State private var password = ""
    @State private var loginSucessful: Bool = false
    @State private var unsucessfulAlert: Bool = false
    
    var body: some View
    {
        NavigationStack()
        {
            VStack(spacing: 20)
            {
                
                Image(systemName: "cube.fill")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 70, height: 80)
                    .font(.largeTitle)
                    .padding()
                    .padding()
                    .background(Color.myColor)
                    .clipShape(Circle())
                Text("LOG IN")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                Text("Username")
                    .frame(width: 300, alignment: .leading)
                TextField("Username", text: $username)
                    .padding()
                    .background(.white)
                    .frame(width: 300)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black))
                Text("Password")
                    .frame(width: 300, alignment: .leading)
                SecureField("Password", text: $password)
                    .padding()
                    .background(.white)
                    .frame(width: 300)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black))
                NavigationLink(destination: Dashboard().navigationBarBackButtonHidden(true), isActive: $loginSucessful) {
                    Button(action: {
                        if loginInfo.keys.contains(username) && loginInfo[username] == password
                        {
                            loginSucessful = true
                        } else
                        {
                            unsucessfulAlert = true
                        }
                        
                    }) {
                        Text("Login")
                            .frame(width: 180, height: 5)
                            .padding()
                            .background(Color.myColor)
                            .cornerRadius(50)
                            .foregroundColor(.white)
                    }
                    .alert(isPresented: $unsucessfulAlert) {
                        Alert(title: Text("Error"), message: Text("Invalid username or password. Try again."), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
}

#Preview {
    Login()
}

