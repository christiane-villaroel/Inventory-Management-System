//
//  SideMenuHeaderView.swift
//  Invertory-App
//
//  Created by Brandon Mccoll on 10/30/24.
//

import SwiftUI
struct MenuData: Identifiable{
    let id = UUID()
    let title: String
    let image: String
}


struct SideMenuHeaderView: View {
    @State var menuItems: [MenuData] = [
        MenuData(title: "Dashboard", image: "Dashboard"),
        MenuData(title: "Inventory", image: "Boxes"),
        MenuData(title: "Transfer", image: "Transfer"),
        MenuData(title: "Retail Stores", image: "!")
      
    ]
    var body: some View {
        HStack{
            Image(systemName: "person.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Color.myColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)
        
            VStack(alignment: .leading, spacing: 6){
                Text("Place Holder")
                    .font(.subheadline)
                Text("placeholder123@gmail.com")
                    .font(.footnote)
                    .tint(.gray)
                
            }//vstack end
        }//hstack end
        List{
            Text("Item 1")
        }
    }//body end
}// view end

#Preview {
    SideMenuHeaderView()
}
