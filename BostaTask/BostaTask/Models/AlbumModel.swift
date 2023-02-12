//
//  AlbumModel.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import Foundation


class AlbumModel: Codable {
    var userId: Int?
    var id: Int?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case id = "id"
        case title = "title"
    }
    
}


