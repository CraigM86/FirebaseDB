//
//  Item.swift
//  FirebaseDB
//
//  Created by MAC on 24/11/20.
//

import Foundation

struct Item: Decodable {
    
    var id: Int
    var name: String
    var description: String
    var imageURL: String
}
