//
//  SparkBuckets.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import Foundation
import SparkUI

struct SparkBuckets {
    
    static let currentUserAuthState = Bucket(SparkAuthState.undefined)
    static let currentUserProfile = Bucket(Profile())
    static let isAdmin = Bucket(false)
    
    static let categories = Bucket([Category]())
    static let items = Bucket([Item]())
    
    static let featuredItems = Bucket([Item]())
    static let indoorItems = Bucket([Item]())
    static let outdoorItems = Bucket([Item]())
    static let accessoryItems = Bucket([Item]())
    
    static let likes = Bucket([Like?]())
}
