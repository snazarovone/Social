//
//  ImageModel.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class ImageModel: Mappable{
    
    private var bucket: String = "jivys"
    var key: String?
    var edits: EditModel?
    
    required init(key: String){
        self.key = key
    }
    
    required init(key: String, edits: EditModel){
        self.key = key
        self.edits = edits
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        bucket <- map["bucket"]
        key <- map["key"]
        edits <- map["edits"]
    }
}
