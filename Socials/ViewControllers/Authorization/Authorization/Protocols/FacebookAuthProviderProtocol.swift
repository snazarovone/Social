//
//  FacebookAuthProviderProtocol.swift
//  Jivys
//
//  Created by Aisana on 30.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import RxSwift

protocol FacebookAuthProviderProtocol {
    var facebookAuthToken: Observable<FacebookAuthToken> {get}
    
    func login(vc: UIViewController)
    func logout()
}
