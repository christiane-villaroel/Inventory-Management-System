import SwiftUI
struct RecieveSortMenu:View {
    @State var reports:[String] = ["Recieve and Sort Reports","Sales Summary","Purchase Summary","Stock Summary"]
    @State var selectedReport:String = "Recieve and Sort Reports"
    
    var body: some View {
        VStack{
            HStack{
                Picker("reports", selection: $selectedReport){
                    ForEach(reports,id:\.self){
                        report in
                        Text(report)
                            .foregroundStyle(.black)
                    }//End foreach
                }//End picker
                .padding(8)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.myColor, lineWidth: 1))
                
                
                
            }
            Image("Graph")
        }//end vstack
    }//end body
}//end view

struct Dashboard: View {
    @State private var searchText = ""
    init(){
        setupNavigationBarAppearance()
    }
    @State private var showMenu = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Main content of the dashboard goes here
                    HStack{
                        Image(systemName: "magnifyingglass")
                        TextField(text: $searchText, label:{Text("Search").foregroundStyle(.black)})
                        
                        
                    }//End HStack
                    .padding(8)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    //Inventory Summary
                    Text("Inventory Summary")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.myColor)
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width:170,height: 100)
                                .foregroundStyle(Color.lightGray)
                                .cornerRadius(10)
                            VStack{
                                Image("Total products")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:50,height:50)
                                Text("Total Products")
                                    .font(.subheadline)
                            }//End Vstack
                            
                        }//End ZStack
                        
                        ZStack{
                            Rectangle()
                                .frame(width:170,height: 100)
                                .foregroundStyle(Color.lightGray)
                                .cornerRadius(10)
                            VStack{
                                Image( "Stock on Hand")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:50,height:50)
                                
                                Text("Stock on Hand")
                                    .font(.subheadline)
                            }//End Vstack
                            
                        }//End ZStack
                        
                    }//End Hstack
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width:170,height: 100)
                                .foregroundStyle(Color.lightGray)
                                .cornerRadius(10)
                            VStack{
                                Image("Quantity In")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:50,height:50)
                                Text("Quantity In")
                                    .font(.subheadline)
                            }//End Vstack
                            
                        }//End ZStack
                        ZStack{
                            Rectangle()
                                .frame(width:170,height: 100)
                                .foregroundStyle(Color.lightGray)
                                .cornerRadius(10)
                            VStack{
                                Image("Quantity out")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:50,height:50)
                                Text("Quantity Out")
                                    .font(.subheadline)
                            }//End Vstack
                            
                        }//End ZStack
                    }//End Hstack
                    HStack{
                        RecieveSortMenu()
                    }//end hstack
                    Spacer()
                }//End VStack
                .padding(8)
                
                SideMenuView(isShowing: $showMenu)
                
            }//End ZStack
            
            .toolbar() {
                // Leading button (menu button)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showMenu.toggle() // Handle menu button action
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .clipShape(Rectangle())
                        
                    }
                    
                    .shadow(color: .black, radius: 10)
                }
                
                ToolbarItem(placement: .principal){
                    Text("Dashboard")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }//End Toolbar
            
                
            
            
            
        }// End NavStack
       
    }//End of ZStack
    // Customize the navigation bar appearance
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.myColor) // Set your custom color here
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Set title color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Set large title color
        
        // Apply the appearance to the navigation bar
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview{
    
        Dashboard()
    
}
