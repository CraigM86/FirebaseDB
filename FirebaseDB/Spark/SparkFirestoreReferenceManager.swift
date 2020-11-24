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
}
