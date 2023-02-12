//
//  UsersNetworking.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import Foundation
import Alamofire

enum UsersNetworking {
    case getUsers
//    case createUser(name: String, job: String)
}

extension UsersNetworking: TargetType {
    var baseURL: String {
        switch self {
        case .getUsers:
            return "https://jsonplaceholder.typicode.com/users/1/"
        }
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return ""
        
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        
        }
    }
    
    var task: Task {
        switch self {
        case .getUsers:
            return .requestPlain
//        case .createUser(let name, let job):
//            return .requestParameters(parameters: ["name": name, "job": job], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
}
