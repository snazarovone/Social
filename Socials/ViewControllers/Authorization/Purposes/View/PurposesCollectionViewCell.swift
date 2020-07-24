//
//  PurposesCollectionViewCell.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import SDWebImage

class PurposesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    weak var dataPurpose: PurposesCellViewModelType?{
        willSet(data){
            name.text = data?.name
            
            if data?.code != "aisana_ios_create_goal"{
                getImg(at: data?.image)
            }else{
                image.image = #imageLiteral(resourceName: "MakeGoal.png")
            }
        }
    }
    
    private func getImg(at url: String?){
        guard let urlStr = url, let urlImage = URL(string: "\(BaseUrl.image.valueStr)\(urlStr)") else {
            //PLACEHOLDER
            return
        }
        image?.sd_setImage(with: urlImage, placeholderImage: nil)
    }
}
