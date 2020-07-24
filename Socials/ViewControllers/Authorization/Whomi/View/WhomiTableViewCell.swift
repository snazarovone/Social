//
//  WhomiTableViewCell.swift
//  Eschty
//
//  Created by Aisana on 25.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class WhomiTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCell: DesignableUIViewEasy!
    @IBOutlet weak var isSelect: DesignableUIImageView!
    @IBOutlet weak var name: UILabel!
    
    weak var dataWhomi: WhomiCellViewModelType?{
        willSet(data){
            viewCell.shadowColor = data?.shadowColor
            viewCell.shadowBlur = data?.shadowBlur ?? 0.0
            viewCell.shadowOffset = data?.shadowOffSet ?? CGPoint(x: 0, y: 0)
            viewCell.shadowOpacity = data?.shadowOpacity ?? 0.0
            isSelect.isHidden = data?.hideCheckSelect ?? true
            name.text = data?.name
            viewCell.backgroundColor = data?.backgroundColor
        }
    }
}
