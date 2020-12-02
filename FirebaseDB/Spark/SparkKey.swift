//
//  SparkKey.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import Foundation

struct SparkKey {
    
    struct CollectionPath {
        static let profiles = "profiles"
        static let admins = "admins"
        static let categories = "categories"
        static let items = "items"
    }
    
    struct StoragePath {
        static let profileImages = "profileImages"
        static let categoryHeaderImages = "categoryHeaderImages"
        static let itemHeaderImages = "itemHeaderImages"
    }
}
