//
//  EditModel.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import Foundation
import ObjectMapper

class EditModel: Mappable{
    
    var resize: ResizeModel?
    
    required init?(map: Map) {
    }
    
    init(resize: ResizeModel) {
        self.resize = resize
    }
    
    func mapping(map: Map) {
        resize <- map["resize"]
    }
    
}
