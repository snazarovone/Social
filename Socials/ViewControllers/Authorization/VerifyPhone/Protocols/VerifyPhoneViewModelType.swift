//
//  VerifyPhoneViewModelType.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol VerifyPhoneViewModelType {
    var phone: String {get}
    var instruction: NSMutableAttributedString {get}
    var code: String {get set}
}
