//
//  SideMenuContentView.swift
//  Invertory-App
//
//  Created by Christiane Villaroel on 11/2/24.
//

import SwiftUI

struct SideMenuContentView: View {
    @State var menuItems: [MenuData] = [
        MenuData(title: "Dashboard", image: "Dashboard",dropdown: false),
        MenuData(title: "Inventory", image: "Boxes",dropdown: true),
        MenuData(title: "Reports", image: "Transfer",dropdown: true),
        MenuData(title: "Notifcations", image: "noti", dropdown: false),
        MenuData(title: "Logout", image: "logout", dropdown: false)
        
      
    ]
    var body: some View {
        
        ZStack{
            List(menuItems){
                item in
                
                HStack{
                    Image(item.image)
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.black)
                        
                }
            }
            .scrollContentBackground(.hidden)
        }
        
    }
}

#Preview {
    SideMenuContentView()
}
