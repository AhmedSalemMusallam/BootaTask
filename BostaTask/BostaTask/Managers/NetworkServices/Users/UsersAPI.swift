//
//  UsersAPI.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import Foundation
protocol UsersAPIProtocol {
    func getUsers(completion: @escaping (Result<UserModel?, NSError>) -> Void)
}


class UsersAPI: BaseAPI<UsersNetworking>, UsersAPIProtocol {
    
    //MARK:- Requests
    
    func getUsers(completion: @escaping (Result<UserModel?, NSError>) -> Void) {
    
        self.fetchData(target: .getUsers, responseClass: UserModel.self) { (result) in
            completion(result)
        }
    }
}
