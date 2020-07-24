//
//  LocationTableViewCell.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectView: DesignableUIViewEasy!
    @IBOutlet weak var name: UILabel!
    
    weak var dataLocation: LocationCellViewModelType?{
        willSet(data){
            self.selectView.isHidden = !(data?.isSelect ?? false)
            self.name?.attributedText = data?.nameFormated
        }
    }
}
