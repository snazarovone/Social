//
//  FacebookAuthToken.swift
//  Jivys
//
//  Created by Aisana on 30.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class FacebookAuthToken{
    
    let accessToken: AccessToken?
    let firstName: String?
    let lastName: String?
    let email: String?
    var birthday: String?
    let photoUrl: String?
    
    
    let error: Error?
    
    init(accessToken: AccessToken?, error: Error?, firstName: String?, lastName: String?, email: String?, birthday: String?, photoUrl: String?){
        self.accessToken = accessToken
        self.error = error
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.birthday = birthday
        self.photoUrl = photoUrl
    }
}

