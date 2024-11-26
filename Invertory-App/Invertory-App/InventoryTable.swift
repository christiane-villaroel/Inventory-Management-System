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
    @State private var inventoryRecords: [InventoryRecord] = []
    @State private var productList: [ProductsTable.ProductData] = []
    @State private var selectedProductId: Int? = nil

    @State private var quantity: String = ""
    @State private var supplierId: String = ""
    @State private var maxLevel: String = ""
    @State private var inventoryLevel: String = ""

    var body: some View {
        VStack {
            Text("Inventory Table")
                .font(.largeTitle)
                .padding()

            // Inventory List
            List {
                ForEach(inventoryRecords) { record in
                    VStack(alignment: .leading) {
                        Text("Product Name: \(productList.first(where: { $0.id == record.productId })?.productName ?? "Unknown")")
                        Text("Quantity: \(record.quantity)")
                        Text("Supplier ID: \(record.supplierId)")
                        Text("Max Level: \(record.maxLevel)")
                        Text("Inventory Level: \(record.inventoryLevel)")
                        Text("Last Updated: \(record.lastUpdated)")
                    }
                }
                .onDelete(perform: deleteInventory)
            }

            // Add Inventory Form
            VStack {
                Text("Add or Update Inventory")
                    .font(.headline)
                    .padding(.top)

                Picker("Select Product", selection: $selectedProductId) {
                    ForEach(productList) { product in
                        Text(product.productName).tag(product.id as Int?)
                    }
                }
                .onAppear {
                    productList = dbHelper.fetchProducts().map { ProductsTable.ProductData(id: $0.0, productName: $0.1, price: $0.2, category: $0.3) }
                }

                TextField("Quantity", text: $quantity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                TextField("Supplier ID", text: $supplierId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                TextField("Max Level", text: $maxLevel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                TextField("Inventory Level", text: $inventoryLevel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                Button(action: addInventory) {
                    Text("Add Entry")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .onAppear(perform: fetchInventory)
    }

    func fetchInventory() {
        let records = dbHelper.fetchInventory()
        inventoryRecords = records.map {
            InventoryRecord(
                id: $0.0,
                productId: $0.1,
                quantity: $0.2,
                supplierId: $0.3,
                maxLevel: $0.4,
                inventoryLevel: $0.5,
                lastUpdated: $0.6
            )
        }
    }

    func addInventory() {
        guard let selectedProductId = selectedProductId,
              let quantityInt = Int(quantity),
              let supplierIdInt = Int(supplierId),
              let maxLevelInt = Int(maxLevel),
              let inventoryLevelInt = Int(inventoryLevel) else {
            print("Invalid input")
            return
        }

        dbHelper.insertInventory(
            productId: selectedProductId,
            quantity: quantityInt,
            supplierId: supplierIdInt,
            maxLevel: maxLevelInt,
            inventoryLevel: inventoryLevelInt,
            lastUpdated: Date().formatted()
        )
        fetchInventory()
    }

    func deleteInventory(at offsets: IndexSet) {
        for index in offsets {
            let record = inventoryRecords[index]
            dbHelper.deleteInventory(inventoryId: record.id)
        }
        fetchInventory()
    }
}

#Preview {
    InventoryTable().environmentObject(DBHelper())
}
