//
//  ConfirmMobileModel.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class ConfirmMobileModel: BaseResponseModel{

    var notFilledFields: [String]?
    var secretToken: String?
    
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
        notFilledFields <- map["notFilledFields"]
        secretToken <- map["secretToken"]
    }
}
