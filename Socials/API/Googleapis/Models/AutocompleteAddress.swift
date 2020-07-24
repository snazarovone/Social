//
//  AutocompleteAddress.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class AutocompleteAddress: Mappable {
    
    var description: String?
    var place_id: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        description <- map["description"]
        place_id <- map["place_id"]
    }
    
    
}
