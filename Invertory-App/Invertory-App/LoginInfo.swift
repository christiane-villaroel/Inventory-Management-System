//
//  LoginInfo.swift
//  Invertory-App
//
//  Created by Allen Chen on 11/3/24.
//

import SwiftUI
import Foundation

struct User: Identifiable{
    let id = UUID()
    let username:String
    let password:String
}

/*@State let loginInfo = [
    "Allen": "C123",
    "Christiane": "V123",
    "Brandon": "M123",
    "Fuat": "Ali123"
]*/
