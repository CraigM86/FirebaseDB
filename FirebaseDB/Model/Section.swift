//
//  Section.swift
//  FirebaseDB
//
//  Created by MAC on 24/11/20.
//

import Foundation
import FirebaseFirestoreSwift

struct Section: Identifiable, Decodable {
    
    @DocumentID var id: String? = UUID().uuidString
    var type: String
    var title: String
    var subtitle: String
    var items: [Item]
}
