//
//  ResultsUsersData.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultsUsersData: BaseResponseModel{
    var total : Int?
    var items : [ItemResultModel]?
    
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
