//
//  AlbumsAPI.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import Foundation

protocol AlbumsAPIProtocol {
    func getAlbums(completion: @escaping (Result<[AlbumModel]?, NSError>) -> Void)
}


class AlbumsAPI: BaseAPI<AlbumsNetworking>, AlbumsAPIProtocol {
    
    //MARK:- Requests
    
    func getAlbums(completion: @escaping (Result<[AlbumModel]?, NSError>) -> Void) {
    
        self.fetchData(target: .getAlbums, responseClass: [AlbumModel].self) { (result) in
            completion(result)
        }
    }
}
