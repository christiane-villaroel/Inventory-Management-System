//
//  InventoryTable.swift
//  Invertory-App
//
//  Created by Christiane Villaroel on 11/12/24.
//

import SwiftUI

struct InventoryTable: View {
    struct BatchData: Identifiable {
        let id = UUID()
        let batchNo: Int
        let product: String
        let variant: String
        let countedQuantity: Int
    }
    
    
    @State private var data: [BatchData] = []
    
    @State private var batchNo = ""
    @State private var product = ""
    @State private var variant = ""
    @State private var countedQuantity = ""
    
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        VStack {
           
            HStack {
                Text("Batch No.")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                Text("Product")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                Text("Variant")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                Text("Counted Quantity")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color(hex: 0xad6800))
            .foregroundColor(.white)
            
            
            List {
                ForEach(data.indices, id: \.self) { index in
                    ZStack {
                       
                        (index.isMultiple(of: 2) ? Color.gray.opacity(0.2) : Color.white)
                            .edgesIgnoringSafeArea(.horizontal)
                        
                       
                        HStack {
                            Text("\(data[index].batchNo)")
                                .frame(maxWidth: .infinity)
                            Text(data[index].product)
                                .frame(maxWidth: .infinity)
                            Text(data[index].variant)
                                .frame(maxWidth: .infinity)
                            Text("\(data[index].countedQuantity)")
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .onDelete(perform: deleteData)
                .onMove(perform: moveData)
            }
            .environment(\.editMode, $editMode)

            Divider()
            
            
            VStack {
                Text("Add New Data")
                    .font(.headline)
                    .padding(.top)
                
                TextField("Batch No.", text: $batchNo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                TextField("Product", text: $product)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Variant", text: $variant)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Counted Quantity", text: $countedQuantity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Button(action: addData) {
                    Text("Add Entry")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0xad6800))
                        .cornerRadius(8)
                        .padding(.top)
                }
            }
            .padding()
            
            
            HStack {
                Button(action: {
                    withAnimation {
                        editMode = (editMode == .active) ? .inactive : .active
                    }
                }) {
                    Text(editMode == .active ? "Done" : "Remove")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: 0xad6800))
                        .cornerRadius(8)
                        .padding(.top)
                }
            }
            .padding()
        }
    }
    
    
    func addData() {
       
        if let batchNoInt = Int(batchNo), let countedQuantityInt = Int(countedQuantity), !product.isEmpty, !variant.isEmpty {
            let newEntry = BatchData(batchNo: batchNoInt, product: product, variant: variant, countedQuantity: countedQuantityInt)
            data.append(newEntry)
            
            batchNo = ""
            product = ""
            variant = ""
            countedQuantity = ""
        }
    }

    
    func deleteData(at offsets: IndexSet) {
        data.remove(atOffsets: offsets)
    }

    
    func moveData(from source: IndexSet, to destination: Int) {
        data.move(fromOffsets: source, toOffset: destination)
    }
}


extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: 1
        )
    }
}

#Preview {
    InventoryTable()
}
