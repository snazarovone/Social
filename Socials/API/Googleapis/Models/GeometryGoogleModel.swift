//
//  GeometryGoogleModel.swift
//  Jivys
//
//  Created by Aisana on 27.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class GeometryGoogleModel: Mappable{
    
    var location: LocationGoogleModel?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        location <- map["location"]
    }
}
