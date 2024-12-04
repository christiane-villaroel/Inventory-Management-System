//
//  EditInventoryView.swift
//  Invertory-App
//
//  Created by Christiane Villaroel on 12/4/24.
//

import SwiftUI

import SwiftUI

struct EditInventoryView: View {
    @State var record: InventoryRecord
    var onSave: (InventoryRecord) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Product Details")) {
                    Text(record.productName)
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                Section(header: Text("Inventory Information")) {
                    Stepper("Quantity: \(record.quantity)", value: $record.quantity, in: 0...9999)
                    Stepper("Inventory Level: \(record.inventoryLevel)", value: $record.inventoryLevel, in: 0...9999)
                    Stepper("Max Level: \(record.maxLevel)", value: $record.maxLevel, in: 0...9999)
                }
            }
            .navigationTitle("Edit Inventory")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(record)
                        dismiss()
                    }
                }
            }
        }
    }

    // Dismiss the modal
    @Environment(\.dismiss) private var dismiss
}


#Preview {
    EditInventoryView(
        record: InventoryRecord(
            id: 1,
            productId: 101,
            productName: "Sample Product",
            quantity: 50,
            supplierId: 10,
            maxLevel: 100,
            inventoryLevel: 75,
            lastUpdated: "2023-11-19"
        ),
        onSave: { updatedRecord in
            // Update the inventory in the database
            print("Saving changes for record: \(updatedRecord)")
            // Call your DBHelper update method here
        }
    )
.environmentObject(DBHelper())
}
