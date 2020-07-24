//
//  GoogleServerAPI.swift
//  Jivys
//
//  Created by Aisana on 27.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum GoogleServerAPI {
    case addressList(latlng: String)
    case placeDetails(place_id: String)
    case autocomplete(input: String)
}

extension GoogleServerAPI: TargetType{
    var baseURL: URL {
        return BaseUrl.google.value
    }
    
    var path: String {
        switch self {
        case .addressList:
            return "geocode/json"
        case .placeDetails:
            return "place/details/json"
        case .autocomplete:
            return "place/autocomplete/json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addressList, .placeDetails, .autocomplete:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .addressList(let latlng):
//            55.803628,49.371856
            var params: [String: String] = ["result_type": "locality", "latlng": latlng]
            
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                let nsDictionary = NSDictionary(contentsOfFile: path)
                if let key = nsDictionary?["GoogleAPIKey"] as? String{
                    params["key"] = key
                }
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
      
        case .placeDetails(let place_id):
            var params: [String: String] = ["fields": "geometry,formatted_address", "place_id": place_id]
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                let nsDictionary = NSDictionary(contentsOfFile: path)
                if let key = nsDictionary?["GoogleAPIKey"] as? String{
                    params["key"] = key
                }
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .autocomplete(let input):
            var params: [String: String] = ["types": "(cities)", "input": input]
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                let nsDictionary = NSDictionary(contentsOfFile: path)
                if let key = nsDictionary?["GoogleAPIKey"] as? String{
                    params["key"] = key
                }
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["accept": "application/json", "content-type": "multipart/form-data"]
    }
    
}
