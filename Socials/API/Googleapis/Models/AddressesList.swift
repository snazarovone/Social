//
//  AddressesList.swift
//  Jivys
//
//  Created by Aisana on 27.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class AddressesList: BaseResponceGoogleModel{
    
    var results: [GoogleResultAddress]?
    
    required init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init(error_message: String?) {
        super.init(error_message: error_message)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        results <- map["results"]
    }
}
