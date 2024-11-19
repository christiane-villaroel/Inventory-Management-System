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
           MenuData(title: "Dashboard", image: "dashboard", dropdown: true, subOptions: ["Option 1", "Option 2"]),
           MenuData(title: "Inventory", image: "Boxes", dropdown: false),
           MenuData(title: "Notifications", image: "Transfer", dropdown: false),
           MenuData(title: "Reports", image: "Reports", dropdown: true, subOptions: ["Monthly", "Yearly"])
       ]
       
       @State var selectedOption = "Dashboard"
       
       var body: some View {
           ZStack {
               List(menuItems.indices, id: \.self) { index in
                   let item = menuItems[index]
                   
                   if item.dropdown {
                       DisclosureGroup(item.title, isExpanded: $isExpanded) {
                           VStack {
                               ForEach(item.subOptions, id: \.self) { option in
                                   Text(option)
                                       .padding()
                                       .onTapGesture {
                                           selectedOption = option
                                       }
                               }
                           }
                       }
                   } else {
                       HStack {
                           Image(item.image)
                               .resizable()
                               .frame(width: 24, height: 24)
                           Text(item.title)
                               .font(.headline)
                               .foregroundStyle(.black)
                       }
                   }
               }
               .scrollContentBackground(.hidden)
           }
       }
}

#Preview {
    DropdownMenu()
}
