//
//  Admin.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import Foundation
import SparkUI
import BetterCodable

struct Admin: Codable {
    
    // MARK: - Properties
    
    @DefaultEmptyString var uid: String
    @DefaultEmptyString var name: String
    
    // MARK: - Initializer
    
    init(uid: String? = nil,
         name: String? = nil) {
        self.uid = uid ?? String.empty
        self.name = name ?? String.empty
    }
    
    init(with dictionary: [String: Any]? = nil) {
        uid = dictionary?[Key.Admin.uid] as? String ?? String.empty
        name = dictionary?[Key.Admin.name] as? String ?? String.empty
    }
    
    // MARK: - Dictionary
    
    func dictionary(mapped: Bool = false) -> [String: Any] {
        if mapped {
            return [
                Key.Admin.uid: uid,
                Key.Admin.name: name
            ]
        } else {
            return [
                Key.Admin.uid: uid,
                Key.Admin.name: name
            ]
        }
    }
    
}

// MARK: - Property Wrapper

struct DefaultEmptyAdminStrategy: DefaultCodableStrategy {
    static var defaultValue: Admin { return Admin() }
}
typealias DefaultEmptyAdmin = DefaultCodable<DefaultEmptyAdminStrategy>

// MARK: - Keys

extension Key {
    struct Admin {
        static let uid = "uid"
        static let name = "name"
    }
}


