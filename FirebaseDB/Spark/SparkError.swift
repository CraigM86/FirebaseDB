//
//  SparkError.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import Foundation

struct SparkAuthError: Error {
    static let noAuthDataResult = NSError(domain: "No Auth Data Result", code: 1, userInfo: nil)
    static let noCurrentUser = NSError(domain: "No Current User", code: 1, userInfo: nil)
    static let noDocumentSnapshot = NSError(domain: "No Document Snapshot", code: 1, userInfo: nil)
    static let noSnapshotData = NSError(domain: "No Snapshot Data", code: 1, userInfo: nil)
}

struct SparkFirestoreError {
    static let noDocumentSnapshot = NSError(domain: "No Document Snapshot", code: 2, userInfo: nil)
    static let noLastDocumentSnapshot = NSError(domain: "No Last Document Snapshot", code: 2, userInfo: nil)
    static let documentDoesNotExist = NSError(domain: "Document Does Not Exist", code: 2, userInfo: nil)
    static let noSnapshotData = NSError(domain: "No Snapshot Data", code: 2, userInfo: nil)
    static let noClientType = NSError(domain: "No Client Type", code: 2, userInfo: nil)
    static let noProfile = NSError(domain: "No Profile", code: 2, userInfo: nil)
    static let noQuerySnapshot = NSError(domain: "No Query Snapshot", code: 2, userInfo: nil)
    static let noQuery = NSError(domain: "No Query", code: 2, userInfo: nil)
    static let noFirstQuery = NSError(domain: "No First Query", code: 2, userInfo: nil)
    static let noNextQuery = NSError(domain: "No Next Query", code: 2, userInfo: nil)
}

struct SparkStorageError: Error {
    static let noImageAvailable = NSError(domain: "No Image Available", code: 3, userInfo: nil)
    static let noUrl = NSError(domain: "No URL", code: 3, userInfo: nil)
}

struct SignInWithAppleAuthError: Error {
    static let noAuthDataResult = NSError(domain: "No Auth Data Result", code: 4, userInfo: nil)
}
