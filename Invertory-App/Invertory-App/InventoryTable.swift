import SwiftUI

struct InventoryRecord: Identifiable {
    let id: Int
    var productId: Int // Include productId to match backend
    let productName: String
    var quantity: Int
    let supplierId: Int
    var maxLevel: Int
    var inventoryLevel: Int
    let lastUpdated: String
}


import SwiftUI

struct InventoryTable: View {
    @EnvironmentObject var dbHelper: DBHelper
    @State private var inventoryRecords: [InventoryRecord] = []
    @State private var editingRecord: InventoryRecord? // Tracks the record being edited
    @State private var showEditSheet = false           // Controls the sheet presentation

    var body: some View {
        NavigationStack {
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
                    Spacer()
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
                            Spacer()

                            // Edit Button
                            Button(action: {
                                editingRecord = record // Set the record to edit
                                showEditSheet = true  // Show the edit sheet
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
            .navigationTitle("Inventory List")
            .onAppear(perform: fetchInventory)
            .sheet(isPresented: $showEditSheet) {
                if let editingRecord = editingRecord {
                    EditInventoryView(
                        record: editingRecord,
                        onSave: { updatedRecord in
                            dbHelper.updateInventory(
                                id: updatedRecord.id,
                                quantity: updatedRecord.quantity,
                                inventoryLevel: updatedRecord.inventoryLevel,
                                maxLevel: updatedRecord.maxLevel
                            )
                            fetchInventory() // Refresh the inventory list
                        }
                    )
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
}


#Preview{
    InventoryTable().environmentObject(DBHelper())
}
