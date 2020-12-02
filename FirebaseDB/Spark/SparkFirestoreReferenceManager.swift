//
//  SparkFirestoreReferenceManager.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import Foundation
import FirebaseFirestore

struct SparkFirestoreReferenceManager {
    
    // MARK: - Profiles
    
    static func referenceForProfile(with uid: String) -> DocumentReference {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.profiles)
            .document(uid)
    }
    
    // MARK: - Categories
    
    static func referenceForCategory(with uid: String) -> DocumentReference {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.categories)
            .document(uid)
    }
    
    static func categoryBase() -> (reference: DocumentReference, uid: String) {
        let reference = SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.categories).document()
        let uid = reference.documentID
        return (reference, uid)
    }
    
    // MARK: - Items
    
    static func referenceForItem(with uid: String) -> DocumentReference {
        return SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.items)
            .document(uid)
    }
    
    static func itemBase() -> (reference: DocumentReference, uid: String) {
        let reference = SparkFirebaseRootReference.firestore
            .collection(SparkKey.CollectionPath.items).document()
        let uid = reference.documentID
        return (reference, uid)
    }
}
