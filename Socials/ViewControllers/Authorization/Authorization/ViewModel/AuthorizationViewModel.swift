//
//  AuthorizationViewModel.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

class AuthorizationViewModel: AuthorizationViewModelType{
    
    private let dataAuthSlider: [AuthSlider]

    init(){
        dataAuthSlider = [AuthSlider(title: nil, img: #imageLiteral(resourceName: "Logo2")),
                          AuthSlider(title: NSLocalizedString("Find people with similar interests and discuss them", comment: "Slider 1"), img: #imageLiteral(resourceName: "slide1.png")),
                          AuthSlider(title: NSLocalizedString("You can find someone to practice a language", comment: "Slider 2"), img: #imageLiteral(resourceName: "slide2.png")),
                          AuthSlider(title: NSLocalizedString("Play video games with people you met here", comment: "Slider 3"), img: #imageLiteral(resourceName: "slide3.png")),
                          AuthSlider(title: NSLocalizedString("Your soulmate waits for you", comment: "Slider 4"), img: #imageLiteral(resourceName: "slide4.png"))]
    }
    
    func nubmerOfRow() -> Int {
        return dataAuthSlider.count
    }
    
    func cellFor(at indexPath: IndexPath) -> AuthorizationCellViewModelType {
        return AuthorizationCellViewModel(authSlider: dataAuthSlider[indexPath.row])
    }
    
     
    public func setValidDate(strDate: String?) -> String?{
        guard let strDate = strDate else {
            return nil
        }
          
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: strDate){
            return getDateInFormat(date: date)
        }else{
            return nil
        }
    }
    
    private func getDateInFormat(date: Date?) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = date{
            return dateFormatter.string(from: date)
        }else{
            return nil
        }
    }
    
    public func requestAauthProviderUser(facebookAuthToken: FacebookAuthToken, callback: @escaping ((ResultResponce, OAuthReg?, ErrorResponce?)->())){
        guard let userID = facebookAuthToken.accessToken?.userID else{
            callback(.fail, nil, nil)
            return
        }
        AuthAPI.requstAuthAPI(type: OAuthReg.self, request: .oAuthRegistrationRequestDto(birthdate: facebookAuthToken.birthday, email: facebookAuthToken.email, name: facebookAuthToken.lastName, oauthProviderUserId: userID, photoUrl: facebookAuthToken.photoUrl)) { [weak self] (value) in
            if value?.isSuccess == true{
                if value?.regToken == nil{
                    AuthToken.shared.setTokenInUD(token: value?.secretToken)
                              
                    self?.getFieldsRequired(at: value?.notFilledFields)
                }
                
                callback(.success, value, nil)
                
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, nil, errorResponce)
            }
        }
    }
    
    private func getFieldsRequired(at fields: [String]?){
        var temp = [FieldsRequired]()
        if let fields = fields{
            for field in fields{
                for f in FieldsRequired.allCases{
                    if f.key.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == field.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(){
                        temp.append(f)
                        break
                    }
                }
            }
        }
        
        AccountRequiredField.shared.fieldsRequired.accept(temp)
    }
}


//Moya_Logger: [03.06.2020, 18:37] Response Body: {"regToken":"5ed7c3b1de931d278e99f899","isSuccess":true}


//{"secretToken":"68b3ce27-0113-4667-b8b7-302a5c029e95","notFilledFields":["PURPOSE"],"isSuccess":true}
