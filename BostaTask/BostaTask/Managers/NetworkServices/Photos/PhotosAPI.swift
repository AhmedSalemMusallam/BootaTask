//
//  PhotosAPI.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import Foundation

protocol PhotosAPIProtocol {
    func getPhotos(albumId:String,completion: @escaping (Result<[PhotoModel]?, NSError>) -> Void)
    func getPhotosSearch(albumId:String , query:String ,completion: @escaping (Result<[PhotoModel]?, NSError>) -> Void)
}


class  PhotosAPI: BaseAPI<PhotosNetworking>, PhotosAPIProtocol {
    
    //MARK:- Requests
    
    func getPhotos(albumId:String,completion: @escaping (Result<[PhotoModel]?, NSError>) -> Void) {
    
        self.fetchData(target: .getPhotos(albumId: albumId), responseClass: [PhotoModel].self) { (result) in
            completion(result)
        }
    }
    
    func getPhotosSearch(albumId: String, query: String, completion: @escaping (Result<[PhotoModel]?, NSError>) -> Void) {
        self.fetchData(target: .getPhotosSearch(albumId: albumId, query: query), responseClass: [PhotoModel].self) { (result) in
            completion(result)
    }
        
    }
}
