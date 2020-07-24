//
//  LoginViewModel.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

class LoginViewModel: LoginViewModelType{
    
    public var phone = ""
    public let regToken: String?
    
    init(regToken: String?){
        self.regToken = regToken
    }
    
    //MARK:- Request
    public func requestSendMobilePhone(callback: @escaping (ResultResponce, BaseResponseModel?) -> ()){
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .sendMobilePhone(mobilePhone: phone)) { (value) in
            if value?.isSuccess == true{
                callback(.success, nil)
            }else{
                callback(.fail, value)
            }
        }
    }
}
