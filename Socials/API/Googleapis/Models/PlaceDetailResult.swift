//
//  PlaceDetailResult.swift
//  Jivys
//
//  Created by Aisana on 27.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class PlaceDetailResult: Mappable{
    
    var formatted_address: String?
    var geometry: GeometryGoogleModel?
       
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        formatted_address <- map["formatted_address"]
        geometry <- map["geometry"]
    }
    
    
}
