//
//  Category.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import Foundation
import SparkUI
import BetterCodable

struct Category: Codable {
    
    // MARK: - Properties
    
    @DefaultEmptyString var uid: String
    @DefaultEmptyString var name: String
    @DefaultEmptyString var headerImageUrl: String
    
    // MARK: - Initializer
    
    init(uid: String? = nil,
         name: String? = nil,
         headerImageUrl: String? = nil) {
        self.uid = uid ?? String.empty
        self.name = name ?? String.empty
        self.headerImageUrl = headerImageUrl ?? String.empty
    }
    
    init(with dictionary: [String: Any]? = nil) {
        uid = dictionary?[Key.Category.uid] as? String ?? String.empty
        name = dictionary?[Key.Category.name] as? String ?? String.empty
        headerImageUrl = dictionary?[Key.Category.headerImageUrl] as? String ?? String.empty
    }
    
    // MARK: - Dictionary
    
    func dictionary(mapped: Bool = false) -> [String: Any] {
        if mapped {
            return [
                Key.Category.uid: uid,
                Key.Category.name: name,
                Key.Category.headerImageUrl: headerImageUrl
            ]
        } else {
            return [
                Key.Category.uid: uid,
                Key.Category.name: name,
                Key.Category.headerImageUrl: headerImageUrl
            ]
        }
    }
    
}

// MARK: - Property Wrapper

struct DefaultEmptyCategoryStrategy: DefaultCodableStrategy {
    static var defaultValue: Category { return Category() }
}
typealias DefaultEmptyCategory = DefaultCodable<DefaultEmptyCategoryStrategy>

// MARK: - Keys

extension Key {
    struct Category {
        static let uid = "uid"
        static let name = "name"
        static let headerImageUrl = "headerImageUrl"
    }
}


