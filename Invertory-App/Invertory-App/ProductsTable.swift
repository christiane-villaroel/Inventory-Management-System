import SwiftUI

struct ProductsTable: View {
    struct ProductData: Identifiable {
        let id: Int
        let productName: String
        let price: Double
        let category: String?
    }
    
    @EnvironmentObject var dbHelper: DBHelper
    @State private var products: [ProductData] = []
    
    @State private var productName = ""
    @State private var price = ""
    @State private var category = ""
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        VStack {
            // Table Header
            HStack {
                Text("Product Name")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                Text("Price")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                Text("Category")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color(hex: 0xad6800))
            .foregroundColor(.white)
            
            // Product List
            List {
                ForEach(products) { product in
                    HStack {
                        Text(product.productName)
                            .frame(maxWidth: .infinity)
                        Text(String(format: "%.2f", product.price))
                            .frame(maxWidth: .infinity)
                        Text(product.category ?? "N/A")
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteProduct)
                .onMove(perform: moveProduct)
            }
            .environment(\.editMode, $editMode)

            Divider()
            
            // Add New Product
            VStack {
                Text("Add New Product")
                    .font(.headline)
                    .padding(.top)
                
                TextField("Product Name", text: $productName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Price", text: $price)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                
                TextField("Category", text: $category)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: addProduct) {
                    Text("Add Product")
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
            
            // Edit Mode Button
            HStack {
                Button(action: {
                    withAnimation {
                        editMode = (editMode == .active) ? .inactive : .active
                    }
                }) {
                    Text(editMode == .active ? "Done" : "Edit")
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
        .onAppear {
            fetchProducts()
        }
    }
    
    func addProduct() {
        guard let priceValue = Double(price), !productName.isEmpty else {
            print("Invalid product details")
            return
        }

        // Check for duplicate product names
        if products.contains(where: { $0.productName.lowercased() == productName.lowercased() }) {
            print("Product already exists")
            return
        }

        dbHelper.insertProduct(productName: productName, price: priceValue, category: category.isEmpty ? nil : category)
        fetchProducts() // Refresh the product list
        productName = ""
        price = ""
        category = ""
    }
    
    func fetchProducts() {
        let fetchedProducts = dbHelper.fetchProducts()
        products = fetchedProducts.map { ProductData(id: $0.0, productName: $0.1, price: $0.2, category: $0.3) }
    }
    
    func deleteProduct(at offsets: IndexSet) {
        for index in offsets {
            let product = products[index]
            dbHelper.deleteProduct(productId: product.id)
        }
        fetchProducts()
    }
    
    func moveProduct(from source: IndexSet, to destination: Int) {
        products.move(fromOffsets: source, toOffset: destination)
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
    ProductsTable().environmentObject(DBHelper())
}
