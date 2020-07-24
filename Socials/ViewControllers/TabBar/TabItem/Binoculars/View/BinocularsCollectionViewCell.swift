//
//  BinocularsCollectionViewCell.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import UIKit
import SDWebImage

class BinocularsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    weak var dataItem: BinocularsCellViewModelType?{
        willSet(data){
            getImg(at: data?.urlStr)
        }
    }
    
    private func getImg(at url: String?){
        guard let urlStr = url, let urlImage = URL(string: "\(BaseUrl.image.valueStr)\(urlStr)") else {
            //PLACEHOLDER
            return
        }
        photo?.sd_setImage(with: urlImage, placeholderImage: nil)
    }
}
