//
//  PredictionsModel.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class PredictionsModel: BaseResponceGoogleModel{
    
    var predictions: [AutocompleteAddress]?
    
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
        
        predictions <- map["predictions"]
    }
}
