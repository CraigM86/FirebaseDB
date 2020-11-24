//
//  Profile.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import Foundation
import SparkUI
import BetterCodable

struct Profile: Codable {
    
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
        uid = dictionary?[Key.Profile.uid] as? String ?? String.empty
        name = dictionary?[Key.Profile.name] as? String ?? String.empty
    }
    
    // MARK: - Dictionary
    
    func dictionary(mapped: Bool = false) -> [String: Any] {
        if mapped {
            return [
                Key.Profile.uid: uid,
                Key.Profile.name: name
            ]
        } else {
            return [
                Key.Profile.uid: uid,
                Key.Profile.name: name
            ]
        }
    }
    
}

// MARK: - Property Wrapper

struct DefaultEmptyProfileStrategy: DefaultCodableStrategy {
    static var defaultValue: Profile { return Profile() }
}
typealias DefaultEmptyProfile = DefaultCodable<DefaultEmptyProfileStrategy>

// MARK: - Keys

extension Key {
    struct Profile {
        static let uid = "uid"
        static let name = "name"
    }
}

