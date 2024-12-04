import SwiftUI

struct InventoryRecord: Identifiable {
    let id: Int
    let productId: Int
    let productName: String
    let quantity: Int
    let supplierId: Int
    let maxLevel: Int
    let inventoryLevel: Int
    let lastUpdated: String
}

struct InventoryTable: View {
    @EnvironmentObject var dbHelper: DBHelper
    @State private var inventoryRecords: [InventoryRecord] = []
    @State private var editingRecord: InventoryRecord?
    @State private var showEditSheet = false
    @State private var showMenu = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Table Header
                    HStack {
                        Text("Product Name")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Quantity")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Inventory Level")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Max Level")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .background(Color.myColor)
                    .foregroundColor(.white)

                    // Inventory List
                    List {
                        ForEach(inventoryRecords) { record in
                            HStack {
                                Text(record.productName)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(record.quantity)")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Text("\(record.inventoryLevel)")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Text("\(record.maxLevel)")
                                    .frame(maxWidth: .infinity, alignment: .center)

                                // Edit Button
                                Button(action: {
                                    editingRecord = record
                                    showEditSheet = true
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .onAppear(perform: fetchInventory)

                // Side Menu
                SideMenuView(isShowing: $showMenu)
            }
            .toolbar {
                // Menu Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showMenu.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundStyle(.white)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Inventory")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showEditSheet) {
                if let record = editingRecord {
                    EditInventoryView(record: record, onSave: { updatedRecord in
                        updateInventory(record: updatedRecord)
                    })
                }
            }
        }
    }

    // Fetch Inventory Records
    func fetchInventory() {
        inventoryRecords = dbHelper.fetchProductInventory().map {
            InventoryRecord(
                id: $0.0,
                productId: $0.1,
                productName: $0.2,
                quantity: $0.3,
                supplierId: $0.4,
                maxLevel: $0.5,
                inventoryLevel: $0.6,
                lastUpdated: $0.7
            )
        }
    }

    // Update Inventory Records
    func updateInventory(record: InventoryRecord) {
        dbHelper.updateInventory(
            id: record.id,
            quantity: record.quantity,
            inventoryLevel: record.inventoryLevel,
            maxLevel: record.maxLevel
        )
        fetchInventory() // Refresh the table
    }
}

#Preview {
    InventoryTable().environmentObject(DBHelper())
}
