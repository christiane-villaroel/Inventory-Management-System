import Foundation
import SQLite3
import SwiftUI

class DBHelper: ObservableObject {
    var db: OpaquePointer?
    var path: String = "inventoryDB.sqlite"

    init() {
        self.db = createDB()
        self.dropUserTable()
        self.createUserTable()
        self.createSuppliersTable()
        self.createProductsTable()
        self.createInventoryTable() // Add this call
        self.createInventoryView()  // Keep this for the InventoryView
    }

    
    func createDB() -> OpaquePointer? {
        let filepath = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent(path)
        sqlite3_exec(db, "PRAGMA foreign_keys = ON;", nil, nil, nil)
        var db: OpaquePointer? = nil
        if sqlite3_open(filepath.path, &db) != SQLITE_OK {
            print("Error creating database.")
            return nil
        } else {
            print("Database created at \(filepath.path)")
            return db
        }
    }
    //USER TABLE CRUD OPERATIONS
    
    // Function to delete the old `User` table if it exists
    func dropUserTable() {
        let dropTableQuery = "DROP TABLE IF EXISTS User;"
        var dropStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, dropTableQuery, -1, &dropStmt, nil) == SQLITE_OK {
            if sqlite3_step(dropStmt) == SQLITE_DONE {
                print("User table dropped successfully.")
            } else {
                print("Could not drop User table.")
            }
        }
        sqlite3_finalize(dropStmt)
    }
    
    // Function to create the new `User` table with a `role` column
    func createUserTable() {
        //dropUserTable() // Drop old table if it exists
        setAdmins()
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS User (
                        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
                        username TEXT NOT NULL UNIQUE,
                        password TEXT NOT NULL,
                        role TEXT NOT NULL,
                        company_name TEXT,
                        email TEXT UNIQUE
                    );
            """
        
        var createTableStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStmt, nil) == SQLITE_OK {
            if sqlite3_step(createTableStmt) == SQLITE_DONE {
                print("User table created successfully.")
            } else {
                print("Could not create User table.")
            }
        }
        sqlite3_finalize(createTableStmt)
    }
    func insertUser(username: String, password: String, role: String, companyName: String? = nil, email: String? = nil) {
            let insertQuery = "INSERT OR IGNORE INTO User (username, password, role, company_name, email) VALUES (?, ?, ?, ?, ?);"
            var insertStmt: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStmt, 1, (username as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStmt, 2, (password as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStmt, 3, (role as NSString).utf8String, -1, nil)
                if let companyName = companyName {
                    sqlite3_bind_text(insertStmt, 4, (companyName as NSString).utf8String, -1, nil)
                } else {
                    sqlite3_bind_null(insertStmt, 4)
                }
                if let email = email {
                    sqlite3_bind_text(insertStmt, 5, (email as NSString).utf8String, -1, nil)
                } else {
                    sqlite3_bind_null(insertStmt, 5)
                }
                if sqlite3_step(insertStmt) == SQLITE_DONE {
                    print("User inserted successfully.")
                } else {
                    print("Could not insert user.")
                }
            }
            sqlite3_finalize(insertStmt)
        }
    func getUser(username: String, password: String) -> (Int, String, String, String, String?, String?)? {
           let query = "SELECT * FROM User WHERE username = ? AND password = ?;"
           var stmt: OpaquePointer? = nil
           
           if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
               sqlite3_bind_text(stmt, 1, (username as NSString).utf8String, -1, nil)
               sqlite3_bind_text(stmt, 2, (password as NSString).utf8String, -1, nil)
               
               if sqlite3_step(stmt) == SQLITE_ROW {
                   let id = Int(sqlite3_column_int(stmt, 0))
                   let username = String(cString: sqlite3_column_text(stmt, 1))
                   let password = String(cString: sqlite3_column_text(stmt, 2))
                   let role = String(cString: sqlite3_column_text(stmt, 3))
                   let companyName = sqlite3_column_text(stmt, 4).flatMap { String(cString: $0) }
                   let email = sqlite3_column_text(stmt, 5).flatMap { String(cString: $0) }
                   sqlite3_finalize(stmt)
                   return (id, username, password, role, companyName, email)
               }
           }
           sqlite3_finalize(stmt)
           return nil
       }
    func setAdmins(){
        let loginInfo = [
            ("Allen", "C123", "Admin/Manager", "CompanyA", "allen@example.com"),
            ("Christiane", "V123", "Admin/Manager", "CompanyB", "christiane@example.com"),
            ("Brandon", "M123", "Admin/Manager", "CompanyC", "brandon@example.com"),
            ("Fuat", "Ali123", "Admin/Manager", "CompanyD", "fuat@example.com")
        ]
        for(username, password, role, company, email) in loginInfo{
            insertUser(username: username, password: password, role: role, companyName: company, email: email)
        }
    }
    
    //SUPPLIERS TABLE CRUD OPERATIONS
    func createSuppliersTable() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS Suppliers (
                supplier_id INTEGER PRIMARY KEY AUTOINCREMENT,
                supplier_name TEXT NOT NULL,
                product_id INTEGER NOT NULL,
                user_id INTEGER NOT NULL,
                restock BOOLEAN NOT NULL,
                stock_amount INTEGER,
                resupply_date DATE,
                company_name TEXT,
                FOREIGN KEY (user_id) REFERENCES User(user_id)
            );
        """
        
        var createTableStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStmt, nil) == SQLITE_OK {
            if sqlite3_step(createTableStmt) == SQLITE_DONE {
                print("Suppliers table created successfully.")
            } else {
                print("Could not create Suppliers table.")
            }
        }
        sqlite3_finalize(createTableStmt)
    }
    //INVENTORY TABLE CRUD OPERATIONS
    func createInventoryView() {
        let createViewQuery = """
            CREATE VIEW IF NOT EXISTS InventoryView AS
            SELECT 
                inventory_id,
                product_id,
                quantity,
                supplier_id,
                Max_level,
                inventory_level,
                CASE 
                    WHEN inventory_level < 0 THEN 'Below minimum'
                    WHEN inventory_level <= Max_level THEN 'Within range'
                    ELSE 'Above maximum'
                END AS level_status,
                last_updated
            FROM Inventory;
        """
        
        var createViewStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createViewQuery, -1, &createViewStmt, nil) == SQLITE_OK {
            if sqlite3_step(createViewStmt) == SQLITE_DONE {
                print("InventoryView created successfully.")
            } else {
                print("Could not create InventoryView.")
            }
        }
        
        sqlite3_finalize(createViewStmt)
    }
    func createInventoryTable() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS Inventory (
                inventory_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each record
                product_id INTEGER NOT NULL,                  -- Foreign key referencing Products
                quantity INTEGER NOT NULL,                    -- Current stock quantity
                supplier_id INTEGER NOT NULL,                 -- Foreign key referencing Suppliers
                Max_level INTEGER NOT NULL,                   -- Max inventory for calculating inventory percentage
                inventory_level INTEGER NOT NULL,             -- Inventory level (range validation applied in queries)
                last_updated DATE NOT NULL,                   -- Date when stock was last updated
                FOREIGN KEY (product_id) REFERENCES Products(product_id),
                FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
            );
        """
        
        var createTableStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStmt, nil) == SQLITE_OK {
            if sqlite3_step(createTableStmt) == SQLITE_DONE {
                print("Inventory table created successfully with foreign key constraints.")
            } else {
                print("Could not create Inventory table.")
            }
        }
        sqlite3_finalize(createTableStmt)
    }

    func insertInventory(productId: Int, quantity: Int, supplierId: Int, maxLevel: Int, inventoryLevel: Int, lastUpdated: String) {
        let insertQuery = """
            INSERT INTO Inventory (product_id, quantity, supplier_id, Max_level, inventory_level, last_updated)
            VALUES (?, ?, ?, ?, ?, ?);
        """
        var insertStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStmt, 1, Int32(productId))
            sqlite3_bind_int(insertStmt, 2, Int32(quantity))
            sqlite3_bind_int(insertStmt, 3, Int32(supplierId))
            sqlite3_bind_int(insertStmt, 4, Int32(maxLevel))
            sqlite3_bind_int(insertStmt, 5, Int32(inventoryLevel))
            sqlite3_bind_text(insertStmt, 6, (lastUpdated as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("Inventory record inserted successfully.")
            } else {
                print("Failed to insert inventory record.")
            }
        }
        sqlite3_finalize(insertStmt)
    }
    func fetchInventory() -> [(Int, Int, Int, Int, Int, Int, String)] {
        let fetchQuery = "SELECT * FROM Inventory;"
        var fetchStmt: OpaquePointer? = nil
        var inventoryRecords: [(Int, Int, Int, Int, Int, Int, String)] = []

        if sqlite3_prepare_v2(db, fetchQuery, -1, &fetchStmt, nil) == SQLITE_OK {
            while sqlite3_step(fetchStmt) == SQLITE_ROW {
                let inventoryId = Int(sqlite3_column_int(fetchStmt, 0))
                let productId = Int(sqlite3_column_int(fetchStmt, 1))
                let quantity = Int(sqlite3_column_int(fetchStmt, 2))
                let supplierId = Int(sqlite3_column_int(fetchStmt, 3))
                let maxLevel = Int(sqlite3_column_int(fetchStmt, 4))
                let inventoryLevel = Int(sqlite3_column_int(fetchStmt, 5))
                let lastUpdated = String(cString: sqlite3_column_text(fetchStmt, 6))
                inventoryRecords.append((inventoryId, productId, quantity, supplierId, maxLevel, inventoryLevel, lastUpdated))
            }
        }
        sqlite3_finalize(fetchStmt)
        return inventoryRecords
    }
    func updateInventory(inventoryId: Int, quantity: Int, maxLevel: Int, inventoryLevel: Int, lastUpdated: String) {
        let updateQuery = """
            UPDATE Inventory 
            SET quantity = ?, Max_level = ?, inventory_level = ?, last_updated = ?
            WHERE inventory_id = ?;
        """
        var updateStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateQuery, -1, &updateStmt, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStmt, 1, Int32(quantity))
            sqlite3_bind_int(updateStmt, 2, Int32(maxLevel))
            sqlite3_bind_int(updateStmt, 3, Int32(inventoryLevel))
            sqlite3_bind_text(updateStmt, 4, (lastUpdated as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStmt, 5, Int32(inventoryId))
            if sqlite3_step(updateStmt) == SQLITE_DONE {
                print("Inventory record updated successfully.")
            } else {
                print("Failed to update inventory record.")
            }
        }
        sqlite3_finalize(updateStmt)
    }
    func deleteInventory(inventoryId: Int) {
        let deleteQuery = "DELETE FROM Inventory WHERE inventory_id = ?;"
        var deleteStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStmt, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStmt, 1, Int32(inventoryId))
            if sqlite3_step(deleteStmt) == SQLITE_DONE {
                print("Inventory record deleted successfully.")
            } else {
                print("Failed to delete inventory record.")
            }
        }
        sqlite3_finalize(deleteStmt)
    }


    // PRODUCTS TABLE CRUD OPERATIONS
    func createProductsTable() {
            let createTableQuery = """
                CREATE TABLE IF NOT EXISTS Products (
                    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    product_name TEXT NOT NULL,
                    price REAL NOT NULL,
                    category TEXT
                );
            """
            
            var createTableStmt: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStmt, nil) == SQLITE_OK {
                if sqlite3_step(createTableStmt) == SQLITE_DONE {
                    print("Products table created successfully.")
                } else {
                    print("Could not create Products table.")
                }
            }
            sqlite3_finalize(createTableStmt)
        }
    func insertProduct(productName: String, price: Double, category: String?) -> Bool {
        let insertQuery = "INSERT INTO Products (product_name, price, category) VALUES (?, ?, ?);"
        var insertStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStmt, 1, (productName as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStmt, 2, price)
            if let category = category {
                sqlite3_bind_text(insertStmt, 3, (category as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(insertStmt, 3)
            }
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("Product inserted successfully.")
                sqlite3_finalize(insertStmt)
                return true
            } else {
                print("Failed to insert product.")
            }
        }
        sqlite3_finalize(insertStmt)
        return false
    }


    
    func fetchProducts() -> [(Int, String, Double, String?)] {
        let fetchQuery = "SELECT * FROM Products;"
        var fetchStmt: OpaquePointer? = nil
        var products: [(Int, String, Double, String?)] = []

        if sqlite3_prepare_v2(db, fetchQuery, -1, &fetchStmt, nil) == SQLITE_OK {
            while sqlite3_step(fetchStmt) == SQLITE_ROW {
                let productId = Int(sqlite3_column_int(fetchStmt, 0))
                let productName = String(cString: sqlite3_column_text(fetchStmt, 1))
                let price = sqlite3_column_double(fetchStmt, 2)
                let category = sqlite3_column_text(fetchStmt, 3).flatMap { String(cString: $0) }
                products.append((productId, productName, price, category))
            }
        }
        sqlite3_finalize(fetchStmt)
        return products
    }
    func updateProduct(productId: Int, productName: String, price: Double, category: String?) {
        let updateQuery = "UPDATE Products SET product_name = ?, price = ?, category = ? WHERE product_id = ?;"
        var updateStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateQuery, -1, &updateStmt, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStmt, 1, (productName as NSString).utf8String, -1, nil)
            sqlite3_bind_double(updateStmt, 2, price)
            if let category = category {
                sqlite3_bind_text(updateStmt, 3, (category as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(updateStmt, 3)
            }
            sqlite3_bind_int(updateStmt, 4, Int32(productId))
            if sqlite3_step(updateStmt) == SQLITE_DONE {
                print("Product updated successfully.")
                
                // Optionally, update related fields in the Inventory table (e.g., last_updated)
                updateInventoryAfterProductEdit(productId: productId)
            } else {
                print("Failed to update product.")
            }
        }
        sqlite3_finalize(updateStmt)
    }

    // Helper function to update inventory after product edits
    func updateInventoryAfterProductEdit(productId: Int) {
        let updateQuery = "UPDATE Inventory SET last_updated = ? WHERE product_id = ?;"
        var updateStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateQuery, -1, &updateStmt, nil) == SQLITE_OK {
            let lastUpdated = Date().formatted()
            sqlite3_bind_text(updateStmt, 1, (lastUpdated as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStmt, 2, Int32(productId))
            if sqlite3_step(updateStmt) == SQLITE_DONE {
                print("Inventory record updated successfully.")
            } else {
                print("Failed to update inventory record.")
            }
        }
        sqlite3_finalize(updateStmt)
    }

    func deleteProduct(productId: Int) {
        let deleteQuery = "DELETE FROM Products WHERE product_id = ?;"
        var deleteStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStmt, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStmt, 1, Int32(productId))
            if sqlite3_step(deleteStmt) == SQLITE_DONE {
                print("Product deleted successfully.")
                
                // Delete associated inventory entry
                deleteInventory(productId: productId)
            } else {
                print("Failed to delete product.")
            }
        }
        sqlite3_finalize(deleteStmt)
    }

    // Helper function to delete inventory when product is deleted
    func deleteInventory(productId: Int) {
        let deleteQuery = "DELETE FROM Inventory WHERE product_id = ?;"
        var deleteStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStmt, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStmt, 1, Int32(productId))
            if sqlite3_step(deleteStmt) == SQLITE_DONE {
                print("Inventory record deleted successfully.")
            } else {
                print("Failed to delete inventory record.")
            }
        }
        sqlite3_finalize(deleteStmt)
    }





}
