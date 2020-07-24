//
//  AccountRequiredFieldType.swift
//  Eschty
//
//  Created by Aisana on 25.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AccountRequiredFieldType {
    var fieldsRequired: BehaviorRelay<[FieldsRequired]> {get set}
    
    func removeField(at field: FieldsRequired)
}
