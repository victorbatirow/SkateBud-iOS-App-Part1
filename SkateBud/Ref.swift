//
//  Ref.swift
//  SkateBud
//
//  Created by Victor on 2022-10-25.
//

import Foundation
import Firebase
import FirebaseStorage

let REF_USER = "users"
let URL_STORAGE_ROOT = "gs://skatebud-fadbc.appspot.com"
let STORAGE_PROFILE = "profile"
let PROFILE_IMAGE_URL = "profileImageUrl"

let UID  = "uid"
let EMAIL = "email"
let USERNAME  = "username"
let STATUS = "status"

let ERROR_EMPTY_PHOTO = "Please choose your profile image"
let ERROR_EMPTY_EMAIL = "Please entar an email address"
let ERROR_EMPTY_USERNAME = "Please enter an username"
let ERROR_EMPTY_PASSWORD = "Pease enter a password"
let ERROR_EMPTY_EMAIL_RESET = "Please enter an email address for password  reset"

let SUCCESS_EMAIL_RESET = "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password"

let IDENTIFIER_WELCOME = "WelcomeVC"
let IDENTIFIER_TABBAR = "TabBarVC"
let IDENTIFIER_CHAT = "ChatVC"

let IDENTIFIER_CELL_USERS = "UserTableViewCell"

class Ref {
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpecificUser(uid: String) ->  DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    // Storage Ref
    
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    
    func storageSpecificProfile(uid:String) -> StorageReference {
        return storageProfile.child(uid)
    }
}
