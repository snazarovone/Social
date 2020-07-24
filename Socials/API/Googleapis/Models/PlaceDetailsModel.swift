//
//  PlaceDetailsModel.swift
//  Jivys
//
//  Created by Aisana on 27.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class PlaceDetailsModel: BaseResponceGoogleModel{
    
    var result: PlaceDetailResult?
    
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
        result <- map["result"]
    }
}
