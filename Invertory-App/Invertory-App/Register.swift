//
//  Register.swift
//  Invertory-App
//
//  Created by Christiane Villaroel on 11/9/24.
//

import SwiftUI

struct Register: View {
    @EnvironmentObject var db: DBHelper
    @State var users: [(Int, String, String)] = []
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var companyName: String = ""
    @State var roleOptions = ["Retail Staff","Admin/Manager", "Supplier"]
    @State var selectedRole: String = ""
    @State var registerSuccessful:Bool = false
    
    var body: some View {
        NavigationStack()
        {
            ScrollView{
                VStack (spacing:20){
                    Image(systemName: "cube.fill")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .font(.largeTitle)
                        .padding()
                        .padding()
                        .background(Color.myColor)
                        .clipShape(Circle())
                    Text("REGISTER")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    Text("Create Username")
                        .frame(width: 300, alignment: .leading)
                    TextField("Username", text: $username)
                        .padding()
                        .background(.white)
                        .frame(width: 300)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black))
                    Text(" Create Password")
                        .frame(width: 300, alignment: .leading)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(.white)
                        .frame(width: 300)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black))
                    Text("Email")
                        .frame(width: 300, alignment: .leading)
                    SecureField("Email", text: $email)
                        .padding()
                        .background(.white)
                        .frame(width: 300)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black))
                    Text("Company Name")
                        .frame(width: 300, alignment: .leading)
                    SecureField("Company Name", text: $companyName)
                        .padding()
                        .background(.white)
                        .frame(width: 300)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black))
                   
                }//End Vstack
            }//scrollview
            Form{
                Picker("Select a Role", selection: $selectedRole){
                    ForEach(roleOptions,id: \.self){
                        Text($0)
                    }
                }
                .pickerStyle(.inline)
               
            }//Form
            NavigationLink(destination: Login().navigationBarBackButtonHidden(true),isActive: $registerSuccessful){
                Button(action:{
                    if !username.isEmpty && !password.isEmpty && !selectedRole.isEmpty && !email.isEmpty{
                        db.insertUser(username: username, password: password,role: selectedRole, companyName: companyName, email: email)
                        registerSuccessful = true
                    }else{
                        registerSuccessful = false
                    }
                }) {
                   Text("Register")
                        .frame(width: 180, height: 5)
                        .padding()
                        .background(Color.myColor)
                        .cornerRadius(50)
                        .foregroundColor(.white)
                }//End Button
                
            }//Nav Link
        }//End NavStack
       
    }//End Body
}//end RegisterView

#Preview {
    //let dbhelper = DBHelper()
    Register()
        .environmentObject(DBHelper())
        
}
