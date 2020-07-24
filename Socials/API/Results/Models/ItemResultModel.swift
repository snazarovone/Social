//
//  ItemResultModel.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class ItemResultModel: Mappable{
    var id : String?
    var name : String?
    var whoAmICode : String?
    var age : Int?
    var distance : Int?
    var photosS3Keys : [String]?
    var matchPercentage : Int?
    var likeType : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        whoAmICode <- map["whoAmICode"]
        age <- map["age"]
        distance <- map["distance"]
        photosS3Keys <- map["photosS3Keys"]
        matchPercentage <- map["matchPercentage"]
        likeType <- map["likeType"]
    }
}
