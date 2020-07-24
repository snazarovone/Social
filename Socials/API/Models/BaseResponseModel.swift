//
//  BaseResponseModel.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponseModel: Mappable{
    
    var errorNumber: Int?
    var errorCode: String?
    var errorDetails: String?
    var isSuccess: Bool?
    var status: Int?
    var error: String?
    var message: String?
    
    
    required init() {
    }
   
    required init(isSuccess: Bool?, errorDetails: String?, status: Int?) {
        self.isSuccess = isSuccess
        self.errorDetails = errorDetails
        self.status = status
    }
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        errorNumber <- map["errorNumber"]
        errorCode <- map["errorCode"]
        errorDetails <- map["errorDetails"]
        isSuccess <- map["isSuccess"]
        status <- map["status"]
        error <- map["error"]
        message <- map["message"]
    }
    
}
