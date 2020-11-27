//
//  SparkFirestore.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import Foundation
import SparkUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SparkFirestore {
    
    // MARK: - Profile
    
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
    
    static func updateCurrentUserProfile(data: [String: Any], completion: @escaping (Result<Bool, Error>) -> ()) {
        let uid = SparkBuckets.currentUserProfile.value.uid
        let reference = SparkFirestoreReferenceManager.referenceForProfile(with: uid)
        reference.updateData(data) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            refreshCurrentUserProfile { (result) in
                completion(result)
            }
        }
    }
    
    static func refreshCurrentUserProfile(completion: @escaping (Result<Bool, Error>) -> () = {_ in}) {
        Console.info("refreshCurrentUserProfile: started...")
        let uid = SparkBuckets.currentUserProfile.value.uid
        Console.info("refreshCurrentUserProfile: started with uid - \(uid )")
        retreiveProfile(uid: uid) { (result) in
            switch result {
            case .success(let profile):
                Console.info("refreshCurrentUserProfile: success - \(profile.uid).")
                SparkBuckets.currentUserProfile.value = profile
                completion(.success(true))
            case .failure(let err):
                Console.info("refreshCurrentUserProfile: error - \(err.localizedDescription)")
                completion(.failure(err))
            }
        }
    }
    
    // MARK: - Admin
    
    static func retreiveAdmins(completion: @escaping (Result<[Admin], Error>) -> ()) {
        let query = SparkFirestoreQueryManager.queryForAdmins()
        query.getDocuments { (querySnapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let querySnapshot = querySnapshot else {
                completion(.failure(SparkFirestoreError.noQuerySnapshot))
                return
            }
            let documents = querySnapshot.documents
            
            var admins = [Admin]()
            for document in documents {
                let result = Result {
                    try document.data(as: Admin.self)
                }
                switch result {
                case .success(let admin):
                    if let admin = admin {
                        admins.append(admin)
                    } else {
                        print("documentDoesNotExist")
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            completion(.success(admins))
        }
    }
    
    // MARK: - Category
    
    static func createCategory(_ category: Category, completion: @escaping (Result<Bool, Error>) -> ()) {
        let categoryBase = SparkFirestoreReferenceManager.categoryBase()
        let reference = categoryBase.reference
        let uid = categoryBase.uid
        
        var updatedCategory = category
        updatedCategory.uid = uid
        
        reference.setData(updatedCategory.dictionary(mapped: true)) { (err) in
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
