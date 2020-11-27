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
}
