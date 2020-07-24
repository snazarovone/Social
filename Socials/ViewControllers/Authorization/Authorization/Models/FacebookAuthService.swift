//
//  FacebookAuthService.swift
//  Jivys
//
//  Created by Aisana on 30.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookAuthService: FacebookAuthProviderProtocol{
    
    var facebookAuthToken: Observable<FacebookAuthToken>{
        return authResultSubject.asObserver()
    }
    
    private let authResultSubject = PublishSubject<FacebookAuthToken>()
    private let loginManager = LoginManager()
    
    func login(vc: UIViewController) {
    
        loginManager.logIn(permissions: ["public_profile", "email", "user_birthday"], from: vc) { [weak self] (result, error) in
            
            if error == nil{
                let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, email, birthday, picture.width(600).height(600)"])
                
                request.start { [weak self] (graphRequestConnection, r, error) in
                    guard let Info = r as? [String: Any] else {
                        let fb = FacebookAuthToken(accessToken: result?.token, error: error, firstName: nil, lastName: nil, email: nil, birthday: nil, photoUrl: nil)
                        self?.authResultSubject.onNext(fb)
                        return
                        
                    }
                    
                    
                    var photoUrl: String?
                    if let pictureUrlFB = Info["picture"] as? [String:Any], let photoData = pictureUrlFB["data"] as? [String:Any]{
                        if let is_silhouette = photoData["is_silhouette"] as? Bool, is_silhouette == false {
                            photoUrl = photoData["url"] as? String
                        }
                    }
                    
                    let fb = FacebookAuthToken(accessToken: result?.token,
                                               error: error,
                                               firstName: Info["first_name"] as? String,
                                               lastName: Info["last_name"] as? String,
                                               email: Info["email"] as? String,
                                               birthday: Info["birthday"] as? String,
                                               photoUrl: photoUrl)
                    self?.authResultSubject.onNext(fb)
                }
            }else{
               let fb = FacebookAuthToken(accessToken: result?.token, error: error, firstName: nil, lastName: nil, email: nil, birthday: nil, photoUrl: nil)
                self?.authResultSubject.onNext(fb)
            }
        }
    }
    
    func logout() {
        if AccessToken.isCurrentAccessTokenActive{
            loginManager.logOut()
        }
    }
}
