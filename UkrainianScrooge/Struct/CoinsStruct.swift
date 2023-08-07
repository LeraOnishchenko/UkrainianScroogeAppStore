//
//  CoinsStruct.swift
//  UkrainianScrooge
//
//  Created by lera
import Foundation
import UIKit

struct Coin: Codable {
    let uuid, name, tag: String
    let imgAv, imgRev: String?
    let nominalVal, startedSellingAt, material: String
    let desc: [String]
    let artists, sculptors: String
    let quantityExp, quantityAct: Int
    let weight: Double?
    let diameter: Double?
    let coinMLUuid: String
    
    init(dict: [String: Any]) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: jsonData)
    }
}

