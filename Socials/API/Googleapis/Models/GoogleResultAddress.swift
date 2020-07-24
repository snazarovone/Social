//
//  GoogleResultAddress.swift
//  Jivys
//
//  Created by Aisana on 27.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class GoogleResultAddress: Mappable{
    
    var place_id: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        place_id <- map["place_id"]
    }
}
