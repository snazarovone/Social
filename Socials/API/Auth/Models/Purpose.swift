//
//  Purpose.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class Purpose: Mappable{
   
    var code: String?
    var presentation: String?
    var imageS3Key: String?
    var isTerminating: Bool?
    
    required init?(map: Map) {
    }
    
    init(code: String, presentation: String){
        self.code = code
        self.presentation = presentation
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        presentation <- map["presentation"]
        imageS3Key <- map["imageS3Key"]
        isTerminating <- map["isTerminating"]
    }
}
