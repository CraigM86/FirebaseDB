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
import FirebaseAuth

struct SparkFirestore {
    
    // MARK: - Profile
    
    static func retreiveProfile(uid: String, completion: @escaping (Result<Profile, Error>) -> ()) {
        let reference = SparkFirestoreReferenceManager.referenceForProfile(with: uid)
        SparkFirestoreHelper<Profile>.getCodable(for: reference, completion: completion)
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
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            completion(.failure(SparkAuthError.noCurrentUser))
            return
        }
        let reference = SparkFirestoreReferenceManager.referenceForProfile(with: currentUserUid)
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
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            completion(.failure(SparkAuthError.noCurrentUser))
            return
        }
        Console.info("refreshCurrentUserProfile: started with uid - \(currentUserUid)")
        retreiveProfile(uid: currentUserUid) { (result) in
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
        SparkFirestoreHelper<Admin>.getCodables(for: query, completion: completion)
    }
    
    // MARK: - Category
    
    static func createCategory(_ category: Category, completion: @escaping (Result<Bool, Error>) -> ()) {
        let base = SparkFirestoreReferenceManager.categoryBase()
        let reference = base.reference
        let uid = base.uid
        
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
    
    static func retreiveCategory(uid: String, completion: @escaping (Result<Category, Error>) -> ()) {
        let reference = SparkFirestoreReferenceManager.referenceForCategory(with: uid)
        SparkFirestoreHelper<Category>.getCodable(for: reference, completion: completion)
    }
    
    static func retreiveCategories(completion: @escaping (Result<[Category], Error>) -> ()) {
        let query = SparkFirestoreQueryManager.queryForCategories()
        SparkFirestoreHelper<Category>.getCodables(for: query, completion: completion)
    }
    
    static func updateCategory(_ category: Category, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        let reference = SparkFirestoreReferenceManager.referenceForCategory(with: category.uid)
        
        reference.updateData(category.dictionary(mapped: true)) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(true))
        }
    }
    
    static func deleteCategory(uid: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let reference = SparkFirestoreReferenceManager.referenceForCategory(with: uid)
        reference.delete { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(true))
        }
    }
    
    // MARK: - Item
    
    static func createItem(_ item: Item, completion: @escaping (Result<Bool, Error>) -> ()) {
        let base = SparkFirestoreReferenceManager.itemBase()
        let reference = base.reference
        let uid = base.uid
        
        var updatedItem = item
        updatedItem.uid = uid
        
        reference.setData(updatedItem.dictionary(mapped: true)) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(true))
        }
    }
    
    static func retreiveItems(categoryUid: String, completion: @escaping (Result<[Item], Error>) -> ()) {
        let query = SparkFirestoreQueryManager.queryForItems(categoryUid: categoryUid)
        SparkFirestoreHelper<Item>.getCodables(for: query, completion: completion)
    }
    
    static func retreiveFeaturedItems(completion: @escaping (Result<[Item], Error>) -> ()) {
        let query = SparkFirestoreQueryManager.queryForFeaturedItems()
        SparkFirestoreHelper<Item>.getCodables(for: query, completion: completion)
    }
    
    static func retreiveItems(ofItemSpace itemSpace: ItemSpace, completion: @escaping (Result<[Item], Error>) -> ()) {
        let query = SparkFirestoreQueryManager.queryForItems(ofItemSpace: itemSpace.rawValue)
        SparkFirestoreHelper<Item>.getCodables(for: query, completion: completion)
    }
    
    static func retreiveItems(ofType itemType: ItemType, completion: @escaping (Result<[Item], Error>) -> ()) {
        let query = SparkFirestoreQueryManager.queryForItems(ofType: itemType.rawValue)
        SparkFirestoreHelper<Item>.getCodables(for: query, completion: completion)
    }
    
    static func retreiveItem(uid: String, completion: @escaping (Result<Item, Error>) -> ()) {
        let reference = SparkFirestoreReferenceManager.referenceForItem(with: uid)
        SparkFirestoreHelper<Item>.getCodable(for: reference, completion: completion)
    }
    
    static func updateItem(_ item: Item, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        let reference = SparkFirestoreReferenceManager.referenceForItem(with: item.uid)
        
        reference.updateData(item.dictionary(mapped: true)) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(true))
        }
    }
    
    static func deleteItem(uid: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let reference = SparkFirestoreReferenceManager.referenceForItem(with: uid)
        reference.delete { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(true))
        }
    }
    
    // MARK: - Like
    
    static func createLike(_ like: Like, completion: @escaping (Result<Like, Error>) -> ()) {
        let base = SparkFirestoreReferenceManager.likeBase()
        let reference = base.reference
        let uid = base.uid
        
        var updatedLike = like
        updatedLike.uid = uid
        
        reference.setData(updatedLike.dictionary(mapped: true)) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(updatedLike))
        }
    }
    
    static func deleteLike(_ like: Like, completion: @escaping (Result<Like, Error>) -> ()) {
        let reference = SparkFirestoreReferenceManager.referenceForLike(with: like.uid)
        reference.delete { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(like))
        }
    }
    
    static func retreiveLike(_ like: Like, completion: @escaping (Result<[Like], Error>) -> ()) {
        let query = SparkFirestoreQueryManager.queryForLike(like)
        SparkFirestoreHelper<Like>.getCodables(for: query, completion: completion)
    }
    
    static func retreiveLikes(ownerUid: String, completion: @escaping (Result<[Like], Error>) -> ()) {
        let query = SparkFirestoreQueryManager.queryForLikes(ownerUid: ownerUid)
        SparkFirestoreHelper<Like>.getCodables(for: query, completion: completion)
    }
    
}

struct SparkFirestoreHelper<T: Codable> {
    
    static func getCodable(for reference: DocumentReference, completion: @escaping (Result<T, Error>) -> ()) {
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
            
            let result = Result {
                try documentSnapshot.data(as: T.self)
            }
            switch result {
            case .success(let object):
                if let object = object {
                    completion(.success(object))
                } else {
                    print("documentDoesNotExist")
                    completion(.failure(SparkFirestoreError.documentDoesNotExist))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    static func getCodables(for query: Query, completion: @escaping (Result<[T], Error>) -> ()) {
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
            
            var objects = [T]()
            for document in documents {
                let result = Result {
                    try document.data(as: T.self)
                }
                switch result {
                case .success(let object):
                    if let object = object {
                        objects.append(object)
                    } else {
                        print("documentDoesNotExist")
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            completion(.success(objects))
        }
    }
}
