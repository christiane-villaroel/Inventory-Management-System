import SwiftUI

struct InventoryManagementView: View {
    @EnvironmentObject var dbHelper: DBHelper
    @State private var inventoryID: Int = 0
    @State private var quantity: Int = 0
    @State private var inventoryLevel: Int = 0
    @State private var maxLevel: Int = 0
    @State private var supplierId: Int = 0
    @State private var isEditing = false
    @State private var showMenu = false

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header: Text("Product Details")) {
                        TextField("Product ID", value: $inventoryID, format: .number)
                            .keyboardType(.numberPad)
                        TextField("Supplier ID", value: $supplierId, format: .number)
                            .keyboardType(.numberPad)
                    }

                    Section(header: Text("Inventory Details")) {
                        TextField("Quantity", value: $quantity, format: .number)
                            .keyboardType(.numberPad)
                        TextField("Inventory Level", value: $inventoryLevel, format: .number)
                            .keyboardType(.numberPad)
                        TextField("Max Level", value: $maxLevel, format: .number)
                            .keyboardType(.numberPad)
                    }

                    Button(action: {
                        if isEditing {
                            print("Updating inventory")
                        } else {
                            print("Adding inventory")
                        }
                    }) {
                        Text(isEditing ? "Update Inventory" : "Add Inventory")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.myColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

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
                    Text("Manage Inventory")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    InventoryManagementView().environmentObject(DBHelper())
}
