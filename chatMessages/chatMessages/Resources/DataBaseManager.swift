//
//  DataBaseManager.swift
//  chatMessages
//
//  Created by Grazielli Berti on 17/01/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
}

//MARK: = Account Management
extension DatabaseManager {
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
        })
        
        completion(true)
    }
    
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
                 "first_name": user.firtsName,
                 "last_name": user.lastName,
        ])
    }
}
