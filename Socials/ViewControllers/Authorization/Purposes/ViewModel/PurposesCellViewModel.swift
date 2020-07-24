//
//  PurposesCellViewModel.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

class PurposesCellViewModel: PurposesCellViewModelType{
  
    var name: String?{
        return purpose.presentation
    }
    var image: String?{
        return getImage()
    }
    
    var code: String?{
        return purpose.code
    }
    
    let purpose: Purpose
    
    init(purpose: Purpose){
        self.purpose = purpose
    }
    
    private func getImage() -> String?{
        if let imageModel = ImageModel(key: purpose.imageS3Key ?? "").toJSONString(){
            return imageModel.toBase64()
        }
        return nil
    }
}
