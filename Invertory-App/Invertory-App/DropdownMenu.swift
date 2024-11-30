//
//  DropdownMenu.swift
//  Invertory-App
//
//  Created by Christiane Villaroel on 11/2/24.
//

import SwiftUI

struct DropdownMenu: View {
    @State private var isExpanded: Bool = false
       @State var menuItems: [MenuData] = [
           MenuData(title: "Dashboard", image: "dashboard"),
           MenuData(title: "Inventory", image: "Boxes"),
           MenuData(title: "Notifications", image: "Transfer"),
           MenuData(title: "Reports", image: "Reports")
       ]
       
       @State var selectedOption = "Dashboard"
       
       var body: some View {
           ZStack {
               List(menuItems.indices, id: \.self) { index in
                   let item = menuItems[index]
                   HStack {
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
    DropdownMenu()
}
