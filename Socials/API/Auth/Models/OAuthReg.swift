//
//  OAuthReg.swift
//  Jivys
//
//  Created by Aisana on 04.06.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class OAuthReg: BaseResponseModel{
   
    var regToken: String?
    
    var secretToken: String?
    var notFilledFields: [String]?
    
    required init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init(isSuccess: Bool?, errorDetails: String?, status: Int?) {
        super.init(isSuccess: isSuccess, errorDetails: errorDetails, status: status)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        regToken <- map["regToken"]
        secretToken <- map["secretToken"]
        notFilledFields <- map["notFilledFields"]
    }
}
