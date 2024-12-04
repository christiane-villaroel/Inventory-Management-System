import SwiftUI

struct Register: View {
    @EnvironmentObject var db: DBHelper
    @State var users: [(Int, String, String)] = []
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var companyName: String = ""
    @State var roleOptions = ["Retail Staff", "Admin/Manager", "Supplier"]
    @State var selectedRole: String = ""
    @State var registerSuccessful: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                  
                    Text("REGISTER")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    
                    // Input Fields
                    InputField(title: "Username", text: $username)
                    InputField(title: "Password", text: $password, isSecure: true)
                    InputField(title: "Email", text: $email)
                    InputField(title: "Company Name", text: $companyName)

                    // Role Picker
                    VStack(alignment: .leading) {
                        Text("Select a Role")
                            .fontWeight(.bold)
                        Picker("Select a Role", selection: $selectedRole) {
                            ForEach(roleOptions, id: \.self) { role in
                                Text(role)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    
                    // Register Button
                    NavigationLink(destination: Login(), isActive: $registerSuccessful) {
                        Button(action: register) {
                            Text("Register")
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(Color.myColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }//Button
                    }//Navlink
                    NavigationLink(destination: Login().navigationBarBackButtonHidden(true)){
                        Text("Log In")
                    }
                }//vstack
                .padding()
            }//Scrollview
        }//navstack
    }//view

    func register() {
        if !username.isEmpty && !password.isEmpty && !selectedRole.isEmpty && !email.isEmpty {
            db.insertUser(username: username, password: password, role: selectedRole, companyName: companyName, email: email)
            registerSuccessful = true
        } else {
            registerSuccessful = false
        }
    }
}

struct InputField: View {
    var title: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .fontWeight(.bold)
            if isSecure {
                SecureField(title, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                TextField(title, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

#Preview {
    Register()
        .environmentObject(DBHelper())
}
