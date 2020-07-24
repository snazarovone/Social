//
//  AuthAPI.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper
import RxSwift
import ObjectMapper
import Alamofire

class AuthAPI{
    static let delegate = UIApplication.shared.delegate as! AppDelegate
    
    static func requstAuthAPI <T>(type: T.Type, request: AuthServerAPI, callback: @escaping (T?)->()) where T : BaseResponseModel{
        delegate.providerAuthServerAPI.rx.request(request).mapObject(T.self).asObservable().subscribe(onNext: { (responce) in
            callback(responce)
        }, onError: { e in
            
            let error = e as! MoyaError
            let responce = T(isSuccess: false, errorDetails: error.localizedDescription, status: error.response?.statusCode)
            callback(responce)
        }, onCompleted: nil, onDisposed: nil).disposed(by: delegate.disposeBag)
    }
}
