//
//  ControllersRequiredType.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ControllersRequiredType {
    var fieldsRequired: BehaviorRelay<[FieldsRequired]> {get}
}
