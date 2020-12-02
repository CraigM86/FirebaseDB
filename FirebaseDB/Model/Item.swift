//
//  Item.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import Foundation
import SparkUI
import BetterCodable

struct Item: Codable {
    
    // MARK: - Properties
    
    @DefaultEmptyString var uid: String
    @DefaultEmptyString var categoryUid: String
    @DefaultEmptyString var name: String
    @DefaultEmptyString var headerImageUrl: String
    
    // MARK: - Initializer
    
    init(uid: String? = nil,
         categoryUid: String? = nil,
         name: String? = nil,
         headerImageUrl: String? = nil) {
        self.uid = uid ?? String.empty
        self.categoryUid = categoryUid ?? String.empty
        self.name = name ?? String.empty
        self.headerImageUrl = headerImageUrl ?? String.empty
    }
    
    init(with dictionary: [String: Any]? = nil) {
        uid = dictionary?[Key.Item.uid] as? String ?? String.empty
        categoryUid = dictionary?[Key.Item.categoryUid] as? String ?? String.empty
        name = dictionary?[Key.Item.name] as? String ?? String.empty
        headerImageUrl = dictionary?[Key.Item.headerImageUrl] as? String ?? String.empty
    }
    
    // MARK: - Dictionary
    
    func dictionary(mapped: Bool = false) -> [String: Any] {
        if mapped {
            return [
                Key.Item.uid: uid,
                Key.Item.categoryUid: categoryUid,
                Key.Item.name: name,
                Key.Item.headerImageUrl: headerImageUrl
            ]
        } else {
            return [
                Key.Item.uid: uid,
                Key.Item.categoryUid: categoryUid,
                Key.Item.name: name,
                Key.Item.headerImageUrl: headerImageUrl
            ]
        }
    }
    
}

// MARK: - Property Wrapper

struct DefaultEmptyItemStrategy: DefaultCodableStrategy {
    static var defaultValue: Item { return Item() }
}
typealias DefaultEmptyItem = DefaultCodable<DefaultEmptyItemStrategy>

// MARK: - Keys

extension Key {
    struct Item {
        static let uid = "uid"
        static let categoryUid = "categoryUid"
        static let name = "name"
        static let headerImageUrl = "headerImageUrl"
    }
}



