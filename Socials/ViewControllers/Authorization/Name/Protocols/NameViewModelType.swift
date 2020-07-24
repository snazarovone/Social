//
//  NameViewModelType.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol NameViewModelType {
    var name: String {get set}
    
    func isValidName() -> Bool
    func requestSendName(callback: @escaping ((ResultResponce, ErrorResponce?)->()))
}
