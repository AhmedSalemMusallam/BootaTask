//
//  PhotoModel.swift
//  BostaTask
//
//  Created by Ahmed Salem on 13/02/2023.
//

import Foundation

class PhotoModel: Codable {
    var albumId: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case albumId = "albumId"
        case id = "id"
        case title = "title"
        case url = "url"
        case thumbnailUrl = "thumbnailUrl"
    }
    
}
