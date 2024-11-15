import Foundation
import SQLite3

class DBHelper: ObservableObject {
    var db: OpaquePointer?
    var path: String = "inventoryDB.sqlite"

    init() {
        self.db = createDB()
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

        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS User (
                user_id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL UNIQUE,
                password TEXT NOT NULL,
                role TEXT NOT NULL
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
    func insertUser(username: String, password: String, role: String) {
        let insertQuery = "INSERT INTO User (username, password, role) VALUES (?, ?, ?);"
        var insertStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStmt, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 2, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 3, (role as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("User with role inserted successfully.")
            } else {
                print("Could not insert user with role.")
            }
        }
        sqlite3_finalize(insertStmt)
    }
    func getUser(username: String,password: String) -> (Int,String,String,String)? {
        let query = "SELECT * FROM User WHERE username = ? AND password = ?;"
        var stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            let username = username as NSString
            let password = password as NSString
            sqlite3_bind_text(stmt, 1, username.utf8String, -1, nil)
            sqlite3_bind_text(stmt,2, password.utf8String, -1, nil)
            
            if sqlite3_step(stmt) == SQLITE_ROW {
                let id = Int(sqlite3_column_int64(stmt, 0))
                let firstName = String(cString: sqlite3_column_text(stmt, 1))
                let lastName = String(cString: sqlite3_column_text(stmt, 2))
                let role = String(cString: sqlite3_column_text(stmt, 3))
                sqlite3_finalize(stmt)
                return (id,firstName,lastName,role)
            }
        }
        sqlite3_finalize(stmt)
        return nil
    }

}
