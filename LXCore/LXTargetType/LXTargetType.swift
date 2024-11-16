//
//  LXTargetType.swift
//  LXCore
//
//  Created by Rafayel Aghayan on 23.10.23.
//

import Foundation
import Alamofire

enum LXHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum LXTask {
    
    case requestPlain
    
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding = JSONEncoding.default)
}

protocol LXTargetType {

    var baseURL: String {get}

    var path: String {get}
    
    var method: LXHTTPMethod {get}
    
    var task: LXTask {get}
    
    var headers: [String: String]? {get}
}
