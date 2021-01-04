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
    
    static func queryForItems(ofItemSpace itemSpace: String) -> Query {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.items)
            .whereField(Key.Item.itemSpace, isEqualTo: itemSpace)
    }
    
    static func queryForItems(ofType itemType: String) -> Query {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.items)
            .whereField(Key.Item.itemType, isEqualTo: itemType)
    }
    
    static func queryForLike(_ like: Like) -> Query {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.likes)
            .whereField(Key.Like.ownerUid, isEqualTo: like.ownerUid)
            .whereField(Key.Like.itemUid, isEqualTo: like.itemUid)
    }
    
    static func queryForLikes(ownerUid: String) -> Query {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.likes)
            .whereField(Key.Like.ownerUid, isEqualTo: ownerUid)
    }
}
