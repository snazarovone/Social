//
//  AuthToken.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

class AuthToken{
    static var shared = AuthToken()
    public var token: String?
    public var tokenComplite: String?
    
    init(){
        getTokenFromUD()
    }
    
    private func getTokenFromUD(){
        token = UserDefaults.standard.value(forKey: UDID.token.key) as? String
        tokenComplite = UserDefaults.standard.value(forKey: UDID.tokenComplite.key) as? String
    }
    
    public func setTokenInUD(token: String?){
        UserDefaults.standard.set(token, forKey: UDID.token.key)
        self.token = token
    }
    
    public func setTokenComplete(){
        UserDefaults.standard.set(token, forKey: UDID.tokenComplite.key)
        self.tokenComplite = token
    }
    
    public func removeToken(){
        self.token = nil
        self.tokenComplite = nil
        UserDefaults.standard.removeObject(forKey: UDID.token.key)
        UserDefaults.standard.removeObject(forKey: UDID.tokenComplite.key)
    }
}
