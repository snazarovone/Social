//
//  BinocularsCellViewModel.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import UIKit

class BinocularsCellViewModel: BinocularsCellViewModelType {
    
    var urlStr: String?{
        return getURLBaseStr()
    }
    
    let photosS3Keys: String
    let size: CGSize
    
    init(photosS3Keys: String, size: CGSize){
        self.photosS3Keys = photosS3Keys
        self.size = size
    }
    
    private func getURLBaseStr() -> String?{
        let resize = ResizeModel(width: Int(size.width), height: Int(size.height))
        let editModel = EditModel(resize: resize)
        let key = photosS3Keys.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
        let imageModel = ImageModel(key: "36ae98ff-f4d5-4c2c-80f9-35a347ce7282", edits: editModel)
        return imageModel.toJSONString()?.toBase64()
    }

}
