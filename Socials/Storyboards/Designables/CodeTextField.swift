//
//  CodeTextField.swift
//  Eschty
//
//  Created by Aisana on 23.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class CodeTextField: UITextField {
    weak var myTextFieldDelegate: CodeTextFieldDelegate?
    
    override func deleteBackward() {
        if text?.isEmpty ?? false {
            myTextFieldDelegate?.textFieldDidEnterBackspace(self)
        }
        
        super.deleteBackward()
    }
    
}
