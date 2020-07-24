//
//  WhomiCellViewModel.swift
//  Eschty
//
//  Created by Aisana on 25.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class WhomiCellViewModel: WhomiCellViewModelType{
    
    var backgroundColor: UIColor{
        if isSelect{
            return .white
        }
        return #colorLiteral(red: 0.9350000024, green: 0.9620000124, blue: 0.9819999933, alpha: 1)
    }
    
    var shadowColor: UIColor?{
        if isSelect{
            return #colorLiteral(red: 0.7609999776, green: 0.8429999948, blue: 0.9029999971, alpha: 1)
        }
        return nil
    }
    
    var shadowBlur: CGFloat{
        if isSelect{
            return 50.0
        }
        return 0.0
    }
    
    var shadowOffSet: CGPoint{
        if isSelect{
            return CGPoint(x: 0, y: 12)
        }
        return CGPoint(x: 0, y: 0)
    }
    
    var shadowOpacity: Float{
        if isSelect{
            return 0.8
        }
        return 0.0
    }
    
    var hideCheckSelect: Bool{
        if isSelect{
            return false
        }
        return true
    }
    
    var name: String?{
        return whoami.presentation
    }
    
    
    let isSelect: Bool
    let whoami: Whoami
    
    init(isSelect: Bool, whoami: Whoami){
        self.isSelect = isSelect
        self.whoami = whoami
    }
}
