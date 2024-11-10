//
//  LoginInfo.swift
//  Invertory-App
//
//  Created by Allen Chen on 11/3/24.
//

import SwiftUI
import Foundation

class User : Identifiable{
    var username:String
    var password:String
 
    
    init ( username:String, password:String){
        self.username = username
        self.password = password
    }
}
/*@State var  loginInfo: [User] = [
  
    
  
]*/

/*@State let loginInfo = [
    "Allen": "C123",
    "Christiane": "V123",
    "Brandon": "M123",
    "Fuat": "Ali123"
]*/
