import SwiftUI

struct InventoryRecord: Identifiable {
    let id: Int
    let productId: Int
    let quantity: Int
    let supplierId: Int
    let maxLevel: Int
    let inventoryLevel: Int
    let lastUpdated: String
}

struct InventoryTable: View {
    @EnvironmentObject var dbHelper: DBHelper
    @State private var inventoryRecords: [(Int, String, Int, Int, Int, Int, String)] = []

    var body: some View {
        NavigationView {
            VStack {
                // Table Header
                HStack {
                    Text("Product Name")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                    Text("Quantity")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                    Text("Inventory Level")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                    Text("Max Level")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                    Text("Supplier ID")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                    Text("Last Updated")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.myColor)
                .foregroundColor(.white)

                // Inventory List
                List {
                    ForEach(inventoryRecords, id: \.0) { record in
                        HStack {
                            Text(record.1) // Product Name
                                .frame(maxWidth: .infinity)
                            Text("\(record.2)") // Quantity
                                .frame(maxWidth: .infinity)
                            Text("\(record.3)") // Inventory Level
                                .frame(maxWidth: .infinity)
                            Text("\(record.4)") // Max Level
                                .frame(maxWidth: .infinity)
                            Text("\(record.5)") // Supplier ID
                                .frame(maxWidth: .infinity)
                            Text(record.6) // Last Updated
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("Inventory List", displayMode: .inline)
            .onAppear(perform: fetchInventory)
        }
    }

    // Fetch Inventory Records
    func fetchInventory() {
        inventoryRecords = dbHelper.fetchProductInventory()
    }
}

#Preview{
    InventoryTable().environmentObject(DBHelper())
}
