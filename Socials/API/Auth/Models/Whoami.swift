//
//  Whoami.swift
//  Eschty
//
//  Created by Aisana on 25.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class Whoami: Mappable {
    
    var code: String?
    var presentation: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        presentation <- map["presentation"]
    }
}
