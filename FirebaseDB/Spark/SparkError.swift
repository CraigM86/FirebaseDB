//
//  SparkError.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 24.11.2020.
//

import Foundation

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
