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

enum CodingKeys: String, CodingKey {
    
    case id = "0"
    case name = "1"
    case description = "2"
    case imageURL = "3"
}
