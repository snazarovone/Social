//
//  NameViewModel.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NameViewModel: NameViewModelType{
 
    var name: String = ""
    
    init(){
    }
    
    func requestSendName(callback: @escaping ((ResultResponce, ErrorResponce?) -> ())) {
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .sendName(name: name)) { (value) in
            if value?.isSuccess == true{
                AccountRequiredField.shared.removeField(at: .name)
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
            }
        }
    }
    
    func isValidName() -> Bool {
         let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Zа-яА-Я].*[a-zA-Zа-яА-Я]$)([^ ]?))$")
         return predicateTest.evaluate(with: name)
     }
}
