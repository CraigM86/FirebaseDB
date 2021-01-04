//
//  Like.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 04.01.2021.
//

import Foundation
import SparkUI
import BetterCodable

struct Like: Codable {
    
    // MARK: - Properties
    
    @DefaultEmptyString var uid: String
    @DefaultEmptyString var ownerUid: String
    @DefaultEmptyString var itemUid: String
    
    // MARK: - Initializer
    
    init(uid: String? = nil,
         ownerUid: String? = nil,
         itemUid: String? = nil) {
        self.uid = uid ?? String.empty
        self.ownerUid = ownerUid ?? String.empty
        self.itemUid = itemUid ?? String.empty
    }
    
    init(with dictionary: [String: Any]? = nil) {
        uid = dictionary?[Key.Like.uid] as? String ?? String.empty
        ownerUid = dictionary?[Key.Like.ownerUid] as? String ?? String.empty
        itemUid = dictionary?[Key.Like.itemUid] as? String ?? String.empty
    }
    
    // MARK: - Dictionary
    
    func dictionary(mapped: Bool = false) -> [String: Any] {
        if mapped {
            return [
                Key.Like.uid: uid,
                Key.Like.ownerUid: ownerUid,
                Key.Like.itemUid: itemUid
            ]
        } else {
            return [
                Key.Like.uid: uid,
                Key.Like.ownerUid: ownerUid,
                Key.Like.itemUid: itemUid
            ]
        }
    }
    
}

// MARK: - Property Wrapper

struct DefaultEmptyLikeStrategy: DefaultCodableStrategy {
    static var defaultValue: Like { return Like() }
}
typealias DefaultEmptyLike = DefaultCodable<DefaultEmptyLikeStrategy>

// MARK: - Keys

extension Key {
    struct Like {
        static let uid = "uid"
        static let ownerUid = "ownerUid"
        static let itemUid = "itemUid"
    }
}

