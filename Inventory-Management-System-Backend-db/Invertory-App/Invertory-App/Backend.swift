//
//  Backend.swift
//  Invertory-App
//
//  Created by Christiane Villaroel on 11/9/24.


import Foundation
import SQLite3

class DBHelper {
    var db: OpaquePointer?
    var path: String = "inventoryDB.sqlite"
    var query: String = ""
   
    init(query : String){
        self.db = createDB()
        self.createTable(query:query)
    }
    func createDB()-> OpaquePointer?{
        let filepath = try! FileManager.default.url(
            for:.documentDirectory,in:.userDomainMask,appropriateFor: nil,create: false ).appendingPathExtension(path)
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filepath.path,&db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        }else{
            print("Database has been created with path \(filepath.path)")
            return db
        }
    }
    func createTable(query: String){
        
        if !query.isEmpty{
            var createTable :OpaquePointer? = nil
            if sqlite3_prepare_v2(self.db, query, -1, &createTable, nil) == SQLITE_OK{
                if sqlite3_step(createTable) == SQLITE_DONE{
                    print("Table createion successful")
                }else{
                    print("Table creation failed")
                }
            }else{
                print("preparation failed")
            }
        }else{
            print("No Table creation query")
        }
    }
    func insertUser(username: String, password: String){
        let insertQuery = "INSERT INTO User (username, password) VALUES (?, ?);"
        var insertStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStmt, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 2, (password as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("User inserted successfully.")
            } else {
                print("Could not insert user.")
            }
        }
    }
    
    func fetchUsers() ->[(Int,String,String)] {
        let selectQuery = "SELECT * FROM User;"
        var selectStmt: OpaquePointer? = nil
        var users: [(Int, String, String)] = []
        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStmt, nil) == SQLITE_OK {
            while sqlite3_step(selectStmt) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(selectStmt, 0))
                let username = String(cString: sqlite3_column_text(selectStmt, 1))
                let password = String(cString: sqlite3_column_text(selectStmt, 2))
                users.append((id, username, password))
            }
        }
        sqlite3_finalize(selectStmt)
        return users
    }
    func deleteUser(id:Int){
        let deleteQuery = "DELETE FROM User WHERE user_id = \(id);"
        var deleteStmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStmt, nil) == SQLITE_OK {
            sqlite3_step(deleteStmt)
        }
    }

  
}//end dbhelper class

//var users = DBHelper(query:"CREATE TABLE User (user_id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT NOT NULL UNIQUE, password TEXT NOT NULL);")


