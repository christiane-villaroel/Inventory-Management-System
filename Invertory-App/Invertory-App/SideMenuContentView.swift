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
    var dropdown: Bool
    var subOptions:[String] = []
}


struct SideMenuContentView: View {
    @State private var isExpanded: Bool = false
    @State var menuItems: [MenuData] = [
        MenuData(title: "Dashboard", image: "dashboard",dropdown: false),
        MenuData(title: "Inventory", image: "Boxes",dropdown: true, subOptions: ["Inventory Calendar", "Inventory Table"]),
        MenuData(title: "Notifications", image: "Transfer",dropdown: false),
        MenuData(title: "Reports", image: "Reports",dropdown: false)
    ]
    @State var selectedOption = "Inventory"
    
    var body: some View {
        NavigationView{
            ZStack{
                List($menuItems){
                    
                        $item in
                       
                        if item.dropdown{
                            DisclosureGroup(item.title){
                                VStack {
                                    ForEach(item.subOptions, id: \.self) {option in
                                        NavigationLink(
                                            destination: getDestinationView(for: option)
                                        ){
                                            Text(option)
                                                .onTapGesture {
                                                    selectedOption = option
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            HStack{
                                Image(item.image)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                                Text(item.title)
                                    .font(.headline)
                                    .foregroundStyle(.black)
                                    
                            }//end hstack
                        }
                    
                }//end List
                .scrollContentBackground(.hidden)
            }//end zstack
            
        }
    }// end body
    @ViewBuilder
    func getDestinationView(for option: String)-> some View{
        switch option{
        case "Inventoy Calendar":
            Dashboard()
        case "Inventory Table":
            InventoryTable()
        default:
            Text("Unknown Destination")
        }
    }
}//end sidMenueContainer

#Preview {
    SideMenuContentView()
}
