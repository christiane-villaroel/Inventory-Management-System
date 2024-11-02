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
        MenuData(title: "Recieve & Sort", image: "Shopping Cart",dropdown: true),
        MenuData(title: "Inventory", image: "Boxes",dropdown: true),
        MenuData(title: "Transfer", image: "Transfer",dropdown: true),
        MenuData(title: "Retail Stores", image: "!",dropdown: false),
        MenuData(title: "Activity Logs", image: "systemName:book.circle.fill",dropdown: false),
        MenuData(title: "Reports", image: "Transfer",dropdown: true)
        
      
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
