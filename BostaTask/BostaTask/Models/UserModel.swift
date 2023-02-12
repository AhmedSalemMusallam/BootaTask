//
//  UserModel.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import Foundation

class UserModel: Codable {
    var name: String?
    var address: Address?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case address = "address"
    }
    
}

class Address: Codable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    
    enum CodingKeys: String, CodingKey {
        case street = "street"
        case suite = "suite"
        case city = "city"
        case zipcode = "zipcode"
    }
}
