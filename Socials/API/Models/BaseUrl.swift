//
//  BaseUrl.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

enum BaseUrl {
    case url
    case google
    case image
}

extension BaseUrl{
    var value: URL{
        switch self {
        case .url:
            return URL(string: "https://api.jivys.com/v1/")!
        case .google:
            return URL(string: "https://maps.googleapis.com/maps/api/")!
        case .image:
            return URL(string: "https://d340vvx7vqw5mj.cloudfront.net/")!
        }
    }
    
    var valueStr: String{
        switch self {
        case .url:
            return "https://api.jivys.com/v1/"
        case .google:
            return "https://maps.googleapis.com/maps/api/"
        case .image:
            return "https://d340vvx7vqw5mj.cloudfront.net/"
        }
    }
}
