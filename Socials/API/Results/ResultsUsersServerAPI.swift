//
//  ResultsUsersServerAPI.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum ResultsUsersServerAPI{
    case results(page: Int, size: Int)
    case likes(userId: String, type: BottomAction)
}

extension ResultsUsersServerAPI: TargetType{
    var baseURL: URL {
        return BaseUrl.url.value
    }
    
    var path: String {
        switch self {
        case .results:
            return "results"
        case .likes(let userId, _):
            return "users/\(userId)/likes"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .results:
            return .get
        case .likes:
            return .post
        }
    }
    
    var task: Task{
        switch self {
        case .results(let page, let size):
            return .requestParameters(parameters: ["page" : page, "size": size], encoding: URLEncoding.queryString)
        case .likes(_, let type):
            return .requestParameters(parameters: ["type" : type.type], encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        let params: [String: String]
        
        switch self {
        case .results, .likes:
            params = ["X-Auth-Token": "\(AuthToken.shared.token ?? "")",
                "accept": "application/json",
                "Accept-Language": "\(LanguageUser.shared.selectLanguge.code)"]
        }
        
        return params
    }
}

