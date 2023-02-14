//
//  PhotosNetworking.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import Foundation
import Alamofire

enum PhotosNetworking {
    case getPhotos(albumId:String)
    case getPhotosSearch(albumId:String,query:String)

}

extension PhotosNetworking: TargetType {
    var baseURL: String {
        switch self {
        case .getPhotos(let albumId):
            return "https://jsonplaceholder.typicode.com/photos?albumId=\(albumId)"
        case .getPhotosSearch(let albumId,let query):
            return "https://jsonplaceholder.typicode.com/photos?albumId=\(albumId)&q=\(query)"
        }
    }
    
    var path: String {
        switch self {
        case .getPhotos:
            return ""
        case .getPhotosSearch:
            return ""
        
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPhotos:
            return .get
        case .getPhotosSearch:
            return .get
        
        }
    }
    
    var task: Task {
        switch self {
        case .getPhotos:
            return .requestPlain
        case .getPhotosSearch:
            return .requestPlain
        }
    }
    
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
}
