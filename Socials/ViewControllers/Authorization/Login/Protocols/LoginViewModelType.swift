//
//  LoginViewModelType.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

protocol LoginViewModelType {
    func requestSendMobilePhone(callback: @escaping (ResultResponce, BaseResponseModel?) -> ())
    
    var phone: String {get set}
}
