//
//  CodeTextFieldDelegate.swift
//  Eschty
//
//  Created by Aisana on 23.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

protocol CodeTextFieldDelegate: class {
    func textFieldDidEnterBackspace(_ textField: CodeTextField)
}
