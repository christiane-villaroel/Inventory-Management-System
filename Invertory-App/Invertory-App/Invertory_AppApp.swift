//
//  Invertory_AppApp.swift
//  Invertory-App
//
//  Created by Brandon Mccoll on 10/16/24.
//

import SwiftUI

@main
struct Invertory_AppApp: App {
   let dbhelper = DBHelper()
    var body: some Scene {
        WindowGroup {
            
            Login()
                .environmentObject(dbhelper)
             
        }
    }
}
