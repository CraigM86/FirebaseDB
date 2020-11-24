//
//  Service.swift
//  FirebaseDB
//
//  Created by MAC on 24/11/20.

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SparkUI

class Service: ObservableObject {
    
    @Published var sections = [Section]()
    
    var db = Firestore.firestore()
    
    static func fetchData() {
        
        db.collection("Furniture").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            self.sections = documents.compactMap{ (queryDocumentSnapshot) -> Section? in
                try? queryDocumentSnapshot.data(as: Section.self)
            }
            print(self.sections.count)
        }
    }
}
