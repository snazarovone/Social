//
//  BaseResponceGoogleModel.swift
//  Jivys
//
//  Created by Aisana on 27.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponceGoogleModel: Mappable{
    
    var error_message: String?
    var status: String?
    
    required init(){
    }
    
    required init(error_message: String?){
        self.error_message = error_message
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        error_message <- map["error_message"]
        status <- map["status"]
    }
    
}
