//
//  AlbumsNetworking.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import Foundation
import Alamofire

enum AlbumsNetworking {
    case getAlbums
//    case createUser(name: String, job: String)
}

extension AlbumsNetworking: TargetType {
    var baseURL: String {
        switch self {
        case .getAlbums:
            return "https://jsonplaceholder.typicode.com/users/1/albums"
        }
    }
    
    var path: String {
        switch self {
        case .getAlbums:
            return ""
        
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAlbums:
            return .get
        
        }
    }
    
    var task: Task {
        switch self {
        case .getAlbums:
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
