//
//  SparkFirebaseRootReference.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import FirebaseFirestore
import FirebaseStorage

struct SparkFirebaseRootReference {
    static let firestore = Firestore.firestore()
    static let baseStorage = Storage.storage()
    static let storage = Storage.storage().reference()
}
