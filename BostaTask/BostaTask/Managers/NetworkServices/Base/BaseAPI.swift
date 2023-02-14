//
//  BaseAPI.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//


import Foundation
import Alamofire


class BaseAPI<T: TargetType> {
    
    
    func fetchData<M: Decodable>(target: T, responseClass: M.Type, completion:@escaping (Result<M?, NSError>) -> Void) {
        
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
       
        guard let url = URL(string: target.baseURL + target.path) else { return }
        print("\(url) 00000000")
        AF.request(url, method: method, parameters: params.0, encoding: params.1, headers: headers).responseDecodable(of: M.self) { (response) in
            
            
            guard let statusCode = response.response?.statusCode else {
                // ADD Custom Error
                let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                completion(.failure(error))
                return
            }
            if statusCode == 200 { // 200 reflect success response
                // Successful request
                guard let jsonResponse = try? response.result.get() else {
                    // ADD Custom Error
                    let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                    completion(.failure(error))
                    return
                }
               
                completion(.success(jsonResponse))
            } else {
                // ADD custom error base on status code 404 / 401 /
                // Error Parsing for the error message from the BE
                let message = "Error Message Parsed From BE"
                let error = NSError(domain: target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                completion(.failure(error))
            }
        }
    }
    
    
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
}
