//
//  AuthorizationCellViewModel.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class AuthorizationCellViewModel: AuthorizationCellViewModelType{
   
    var titleSlider: String?{
        return authSlider.title
    }
    
    var img: UIImage?{
        return authSlider.img
    }
    
    let authSlider: AuthSlider
    
    init(authSlider: AuthSlider){
        self.authSlider = authSlider
    }
}
