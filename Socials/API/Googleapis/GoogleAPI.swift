//
//  GoogleAPI.swift
//  Jivys
//
//  Created by Aisana on 27.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper
import RxSwift
import ObjectMapper
import Alamofire

class GoogleAPI{
    static let delegate = UIApplication.shared.delegate as! AppDelegate
    
    static func requestGoogleAPI <T>(type: T.Type, request: GoogleServerAPI, callback: @escaping (T?)->()) where T : BaseResponceGoogleModel{
        
        delegate.providerGoogleServerAPI.session.session.getAllTasks { (value) in
            for task in value{
                if let currentRequest = task.currentRequest,
                    let url = currentRequest.url, url == URL(string: "\(request.baseURL.absoluteString)\(request.path)"){
                    task.cancel()
                }
            }
            
            
            delegate.providerGoogleServerAPI.rx.request(request).mapObject(T.self).asObservable().subscribe(onNext: { (responce) in
                callback(responce)
            }, onError: { e in
                
                let error = e as! MoyaError
                let responce = T(error_message: error.localizedDescription)
                callback(responce)
            }, onCompleted: nil, onDisposed: nil).disposed(by: delegate.disposeBag)
        }
    }
}
