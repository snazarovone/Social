//
//  ResultsUsersAPI.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper
import RxSwift
import ObjectMapper
import Alamofire


class ResultsUsersAPI{
    static let delegate = UIApplication.shared.delegate as! AppDelegate
    
    static func requstResultsUserAPI <T>(type: T.Type, request: ResultsUsersServerAPI, callback: @escaping (T?)->()) where T : BaseResponseModel{
        
        delegate.providerResultsServerAPI.rx.request(request).filterSuccessfulStatusCodes().mapObject(T.self).asObservable().subscribe(onNext: { (responce) in
            callback(responce)
        }, onError: { e in
            
            let error = e as! MoyaError
            let status = error.response?.statusCode
            if error.localizedDescription.contains("URLSessionTask failed with error"){
                let responce =  T(isSuccess: false, errorDetails: NSLocalizedString("No internet connection", comment: "No internet connection"), status: status)
                callback(responce)
            }else{
                let responce = T(isSuccess: false, errorDetails: error.localizedDescription, status: status)
                callback(responce)
            }
        }, onCompleted: nil, onDisposed: nil).disposed(by: delegate.disposeBag)
    }
}
