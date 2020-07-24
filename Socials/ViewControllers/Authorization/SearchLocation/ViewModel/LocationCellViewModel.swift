//
//  LocationCellViewModel.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class LocationCellViewModel: LocationCellViewModelType{
    
    let name: String
    let inputText: String
    let isSelect: Bool
    
    var nameFormated: NSMutableAttributedString?{
        let text = name
        let textHighlight = inputText
        
        let rangeFullText = NSString(string: text).range(of: text, options: String.CompareOptions.caseInsensitive)
        let rangeHighlight = NSString(string: text).range(of: textHighlight, options: String.CompareOptions.caseInsensitive)
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6140000224, green: 0.7039999962, blue: 0.7889999747, alpha: 1),
                                            NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Light", size: 14)!], range: rangeFullText)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1089999974, green: 0.2720000148, blue: 0.4589999914, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Regular", size: 14)!], range: rangeHighlight)
        return attributedString
    }
    
    init(name: String, inputText: String, isSelect: Bool){
        self.name = name
        self.inputText = inputText
        self.isSelect = isSelect
    }
}
