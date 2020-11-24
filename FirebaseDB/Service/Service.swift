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
    
    var dbRef = Firestore.firestore()
    
    init(){
        dbRef.collection("furniture").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            self.sections = documents.compactMap{ (queryDocumentSnapshot) -> Section? in
                try? queryDocumentSnapshot.data(as: Section.self)
            }
            print(documents)
        }
    }
    
}
