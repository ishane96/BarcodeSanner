//
//  Item.swift
//  techTest
//
//  Created by Achintha kahawalage on 2022-11-01.
//

import Foundation

class Item: Codable {
    
    let key: String?
    let itemDescription: String?
    let image: String?
    let price: Double?
    var qty = 1 //assigned 1, because of always quantity starting 1
    
    public init (key: String?, itemDescription: String?,image: String?,price: Double?){
        self.key = key
        self.itemDescription = itemDescription
        self.image = image
        self.price = price
    }
    enum CodingKeys: String, CodingKey {
        case itemDescription = "description"
        case image, price, qty, key
    }
    
    
}
