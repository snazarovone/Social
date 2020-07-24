//
//  ResizeModel.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class ResizeModel: Mappable {
    
    var width: Int?
    var height: Int?
    private var fit: String = "contain"
    
    required init?(map: Map) {
    }
    
    init(width: Int, height: Int){
        self.width = width
        self.height = height
    }
    
    func mapping(map: Map) {
        height <- map["height"]
        fit <- map["fit"]
    }
}
