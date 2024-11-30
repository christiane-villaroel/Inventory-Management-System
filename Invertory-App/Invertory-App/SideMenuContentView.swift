//
//  SideMenuContentView.swift
//  Invertory-App
//
//  Created by Christiane Villaroel on 11/2/24.
//

import SwiftUI
struct MenuData: Identifiable{
    var id = UUID()
    var title: String
    var image: String
   
}


struct SideMenuContentView: View {
    @State private var isExpanded: Bool = false
    @State var menuItems: [MenuData] = [
        MenuData(title: "Dashboard", image: "dashboard"),
        MenuData(title: "Inventory", image: "Boxes"),
        MenuData(title: "Notifications", image: "Transfer"),
        MenuData(title: "Reports", image: "Reports")
    ]
    @State var selectedOption = "Inventory"
    
    var body: some View {
        NavigationView{
            ZStack{
                List{
 
                        
                    NavigationLink(destination:Dashboard()){
                        Image("dashboard")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("Dashboard")
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                    NavigationLink(destination:ProductsTable()){
                        Image("Quantity In")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("Update Product Details")
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                    NavigationLink(destination:InventoryTable()){
                        Image("Reports")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.myColor)
                        
                        Text("Inventory Details")
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                    NavigationLink(destination:InventoryManagementView()){
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.myColor)
                        
                        Text("Update Inventory")
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                    
                    
                            /*HStack{
                                Image(item.image)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                                Text(item.title)
                                    .font(.headline)
                                    .foregroundStyle(.black)
                                    
                            }//end hstack*/
                    
                }//end List
                .scrollContentBackground(.hidden)
            }//end zstack
            
        }
    }// end body
}//end sidMenueContainer

#Preview {
    SideMenuContentView()
}
