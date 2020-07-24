//
//  PurposesModel.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class PurposesModel: BaseResponseModel{
   
    var total: Int?
    var items: [Purpose]?
    
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
        
        total <- map["total"]
        items <- map["items"]
    }
}
