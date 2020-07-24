//
//  LocationGoogleModel.swift
//  Jivys
//
//  Created by Aisana on 27.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class LocationGoogleModel: Mappable {
    
    var lat: Double?
    var lng: Double?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
    
}
