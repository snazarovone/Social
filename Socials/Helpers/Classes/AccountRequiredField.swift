//
//  AccountRequiredField.swift
//  Eschty
//
//  Created by Aisana on 25.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AccountRequiredField: AccountRequiredFieldType{
    static var shared = AccountRequiredField()
    
    public var fieldsRequired: BehaviorRelay<[FieldsRequired]> = BehaviorRelay(value: [])
    
    init(){
        
    }
    
    public func removeField(at field: FieldsRequired){
        var tempFields = [FieldsRequired]()
        for f in fieldsRequired.value{
            if f.key != field.key{
                tempFields.append(f)
            }
        }
        fieldsRequired.accept(tempFields)
    }
}
