//
//  BaseResponse.swift
//  BostaTask
//
//  Created by Ahmed Salem on 12/02/2023.
//

import Foundation


class BaseResponse<T: Codable>: Codable {
    var status: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}
