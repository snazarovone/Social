//
//  HandlerError.swift
//  Eschty
//
//  Created by Aisana on 25.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

class HandlerError: HandlerErrorType{
    static var shared = HandlerError()
    
    init() {
        
    }
    
    public func accessDenied(){
        AuthToken.shared.removeToken()
    }
    
    public func getMessage(at value: BaseResponseModel?) -> ErrorResponce?{
        if ErrorResponce.forbidden.statusCode == value?.status,
            let message = value?.message,
            message == ErrorResponce.forbidden.message{
            accessDenied()
            return .forbidden
        }
        
        if ErrorResponce.unauthorized.statusCode == value?.status{
            accessDenied()
            return .unauthorized
        }
        
        if let m = value?.errorDetails{
            return ErrorResponce.detailError(message: m , error: nil)
        }
        return ErrorResponce.detailError(message: value?.message , error: nil)
    }
}
