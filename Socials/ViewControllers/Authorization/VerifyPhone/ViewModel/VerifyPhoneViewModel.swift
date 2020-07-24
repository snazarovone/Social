//
//  VerifyPhoneViewModel.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VerifyPhoneViewModel: VerifyPhoneViewModelType{
    
    var phone: String
    var code: String = ""
    
    private let regToken: String?
    
    var instruction: NSMutableAttributedString{
        let text1 = NSLocalizedString("Please type the verification code\nsend to", comment: "Verify Phone title")
        let text2 = phone
        
        let fullText = "\(text1) \(text2)"
       
        let rangeFullText = NSString(string: fullText).range(of: fullText, options: String.CompareOptions.caseInsensitive)
        let rangePhone = NSString(string: fullText).range(of: text2, options: String.CompareOptions.caseInsensitive)
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6140000224, green: 0.7039999962, blue: 0.7889999747, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Regular", size: 16)!], range: rangeFullText)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1089999974, green: 0.2720000148, blue: 0.4589999914, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Medium", size: 16)!], range: rangePhone)
        return attributedString
    }
    
    init(phone: String, regToken: String?) {
        self.phone = phone
        self.regToken = regToken
    }
    
    
//    private func protectedPhoneNumber() -> String{
//        var result: String = ""
//        for (i, c) in phone.enumerated(){
//            if i <= 8 || i >= 16{
//                result += String(c)
//            }else{
//                if String(c) == " " || String(c) == "-"{
//                    result += String(" ")
//                }else{
//                    result += "*"
//                }
//            }
//        }
//        return result
//    }
    
    //MARK:- Request
    public func requestCheckCode(callback: @escaping ((ResultResponce)->())){
        AuthAPI.requstAuthAPI(type: ConfirmMobileModel.self, request: .confirmMobilePhone(code: code, mobilePhone: phone, regToken: regToken)) { [weak self] (value) in
            if value?.isSuccess == true{
                AuthToken.shared.setTokenInUD(token: value?.secretToken)
               
                self?.getFieldsRequired(at: value?.notFilledFields)
               
                callback(.success)
            }else{
                AuthToken.shared.removeToken()
                callback(.fail)
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
