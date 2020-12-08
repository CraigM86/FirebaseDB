//
//  SparkFirestoreQueryManager.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import SparkUI
import FirebaseFirestore

struct SparkFirestoreQueryManager {
    
    // MARK: - Client Profiles of Author
    
    static func queryForAdmins() -> Query {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.admins)
    }
    
    static func queryForCategories() -> Query {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.categories)
    }
    
    static func queryForItems(categoryUid: String) -> Query {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.items)
            .whereField(Key.Item.categoryUid, isEqualTo: categoryUid)
    }
    
    static func queryForFeaturedItems() -> Query {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.items)
            .whereField(Key.Item.isFeatured, isEqualTo: true)
    }
}
