//
//  ChatAppUser.swift
//  chatMessages
//
//  Created by Grazielli Berti on 17/01/22.
//

import Foundation

struct ChatAppUser {
    let firtsName: String
    let lastName: String
    let emailAddress: String
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture_png"
    }
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
