//
//  EmailViewModel.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EmailViewModel: EmailViewModelType{
    
    var email: String = ""
    
    init(){
    }
    
    //MARK:- Request
    public func requestSendEmail(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .registerEmail(email: email)) {(value) in
            if value?.isSuccess == true{
                AccountRequiredField.shared.removeField(at: .email)
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
                
            }
        }
    }
}
