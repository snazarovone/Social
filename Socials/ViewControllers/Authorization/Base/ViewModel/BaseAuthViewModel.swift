//
//  BaseAuthViewModel.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseAuthViewModel: ControllersRequiredType{
    var fieldsRequired: BehaviorRelay<[FieldsRequired]>
    
    init(){
        self.fieldsRequired = AccountRequiredField.shared.fieldsRequired
    }
}
