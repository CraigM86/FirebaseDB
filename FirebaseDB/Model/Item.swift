//
//  Item.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import Foundation
import SparkUI
import BetterCodable

enum ItemType: String {
    case undefined = ""
    case accessory = "accessory"
}

enum ItemSpace: String {
    case undefined = ""
    case outdoor = "outdoor"
    case indoor = "indoor"
}

struct Item: Codable {
    
    // MARK: - Properties
    
    @DefaultEmptyString var uid: String
    @DefaultEmptyString var categoryUid: String
    @DefaultEmptyString var name: String
    @DefaultEmptyString var headerImageUrl: String
    @DefaultFalse var isFeatured: Bool
    @DefaultEmptyString var itemSpace: String
    @DefaultEmptyString var itemType: String
    
    // MARK: - Initializer
    
    init(uid: String? = nil,
         categoryUid: String? = nil,
         name: String? = nil,
         headerImageUrl: String? = nil,
         isFeatured: Bool? = nil,
         itemSpace: String? = nil,
         itemType: String? = nil) {
        self.uid = uid ?? String.empty
        self.categoryUid = categoryUid ?? String.empty
        self.name = name ?? String.empty
        self.headerImageUrl = headerImageUrl ?? String.empty
        self.isFeatured = isFeatured ?? false
        self.itemSpace = itemSpace ?? String.empty
        self.itemType = itemType ?? String.empty
    }
    
    init(with dictionary: [String: Any]? = nil) {
        uid = dictionary?[Key.Item.uid] as? String ?? String.empty
        categoryUid = dictionary?[Key.Item.categoryUid] as? String ?? String.empty
        name = dictionary?[Key.Item.name] as? String ?? String.empty
        headerImageUrl = dictionary?[Key.Item.headerImageUrl] as? String ?? String.empty
        isFeatured = dictionary?[Key.Item.isFeatured] as? Bool ?? false
        itemSpace = dictionary?[Key.Item.itemSpace] as? String ?? String.empty
        itemType = dictionary?[Key.Item.itemType] as? String ?? String.empty
        
    }
    
    // MARK: - Dictionary
    
    func dictionary(mapped: Bool = false) -> [String: Any] {
        if mapped {
            return [
                Key.Item.uid: uid,
                Key.Item.categoryUid: categoryUid,
                Key.Item.name: name,
                Key.Item.headerImageUrl: headerImageUrl,
                Key.Item.isFeatured: isFeatured,
                Key.Item.itemSpace: itemSpace,
                Key.Item.itemType: itemType
            ]
        } else {
            return [
                Key.Item.uid: uid,
                Key.Item.categoryUid: categoryUid,
                Key.Item.name: name,
                Key.Item.headerImageUrl: headerImageUrl,
                Key.Item.isFeatured: isFeatured,
                Key.Item.itemSpace: itemSpace,
                Key.Item.itemType: itemType
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
        static let isFeatured = "isFeatured"
        static let itemSpace = "itemSpace"
        static let itemType = "itemType"
    }
}



