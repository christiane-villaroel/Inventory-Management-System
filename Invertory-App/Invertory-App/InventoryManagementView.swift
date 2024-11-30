//
//  InventoryManagementView.swift
//  Invertory-App
//
//  Created by Christiane Villaroel on 11/30/24.
//

import SwiftUI

struct InventoryManagementView: View {
    @EnvironmentObject var dbHelper: DBHelper
    @State private var inventoryID: Int = 0
    @State private var quantity: Int = 0
    @State private var inventoryLevel: Int = 0
    @State private var maxLevel: Int = 0
    @State private var supplierId: Int = 0
    @State private var isEditing = false

    var body: some View {
        NavigationView {
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
                            print("updating inventory")
                    } else {
                        /*dbHelper.addInventory(inventoryId: inventoryID, quantity: quantity, inventoryLevel: inventoryLevel, maxLevel: maxLevel, supplierId: supplierId)*/
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
            .navigationTitle(isEditing ? "Edit Inventory" : "Add Inventory")
        }
    }
}


#Preview {
    InventoryManagementView().environmentObject(DBHelper())
}
