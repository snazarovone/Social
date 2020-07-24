//
//  AuthorizationCollectionViewCell.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class AuthorizationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleSlider: UILabel!
    
    
    weak var dataAuth: AuthorizationCellViewModelType?{
        willSet(data){
            self.img.image = data?.img
            self.titleSlider.text = data?.titleSlider
        }
    }
}
