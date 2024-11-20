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
    }
    
    func createDB() -> OpaquePointer? {
        let filepath = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent(path)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(filepath.path, &db) != SQLITE_OK {
            print("Error creating database.")
            return nil
        } else {
            print("Database created at \(filepath.path)")
            return db
        }
    }
    
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


}
