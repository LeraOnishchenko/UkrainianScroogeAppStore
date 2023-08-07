//
//  UserStruct.swift
//  UkrainianScrooge
//
//  Created by lera 

import Foundation
import FirebaseFirestoreSwift
struct User : Codable {
    
    @DocumentID var id: String?
    var firstName, lastName: String

    init(dict: [String: Any]) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: jsonData)
    }
    
    init(firstname: String, lastname: String) {
        self.firstName = firstname
        self.lastName = lastname
    }
    
}

struct UserCoin : Codable {
    @DocumentID var id: String?
    var note, quality : String
    var price: Double
    
    init(dict: [String: Any], id: String) throws {
        note = dict["note"] as! String
        quality = dict["quality"] as! String
        price = dict["price"] as! Double
    }
    
    init(note: String, price: Double, quality: String) {
        self.note = note
        self.price = price
        self.quality = quality
    }
}
