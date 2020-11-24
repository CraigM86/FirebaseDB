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
}
