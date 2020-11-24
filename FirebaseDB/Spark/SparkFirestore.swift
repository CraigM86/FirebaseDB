//
//  SparkFirestore.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import Foundation
import FirebaseFirestore

struct SparkFirestore {
    
    static func retreiveProfile(uid: String, completion: @escaping (Result<Profile, Error>) -> ()) {
        let reference = SparkFirestoreReferenceManager.referenceForProfile(with: uid)
        getDocument(for: reference) { (result) in
            switch result {
            case .success(let data):
                let profile = Profile(with: data)
                completion(.success(profile))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    static func createProfile(_ profile: Profile, completion: @escaping (Result<Bool, Error>) -> ()) {
        let reference = SparkFirestoreReferenceManager.referenceForProfile(with: profile.uid)
        reference.setData(profile.dictionary(mapped: true)) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(true))
        }
    }
    
    // MARK: - fileprivate Firestore functions
    
    static fileprivate func getDocument(for reference: DocumentReference, completion: @escaping (Result<[String : Any], Error>) -> ()) {
        reference.getDocument { (documentSnapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let documentSnapshot = documentSnapshot else {
                completion(.failure(SparkFirestoreError.noDocumentSnapshot))
                return
            }
            if !documentSnapshot.exists {
                completion(.failure(SparkFirestoreError.documentDoesNotExist))
                return
            }
            guard let data = documentSnapshot.data() else {
                completion(.failure(SparkFirestoreError.noSnapshotData))
                return
            }
            completion(.success(data))
        }
    }
}
