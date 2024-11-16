//
//  TargetType.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 25.06.23.
//

import Foundation
import Alamofire

enum LXIOSCoreNetworkLayerHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum LXIOSCoreNetworkLayerTask {
    
    case requestPlain
    
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding = JSONEncoding.default)
}

protocol LXIOSCoreNetworkLayerTargetType {

    var baseURL: String {get}

    var path: String {get}
    
    var method: LXIOSCoreNetworkLayerHTTPMethod {get}
    
    var task: LXIOSCoreNetworkLayerTask {get}
    
    var headers: [String: String]? {get}
}
