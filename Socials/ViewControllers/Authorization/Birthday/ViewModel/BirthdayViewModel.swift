//
//  BirthdayViewModel.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

class BirthdayViewModel: BirthdayViewModelType{
    
    var bitrhday: String = ""
    
    init(){
        
    }
    
    public func validBithDate() -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let d = dateFormatter.date(from: bitrhday){
            let dateNow = Date()
            if d.timeIntervalSince1970 > dateNow.timeIntervalSince1970{
                return false
            }else{
                let calendar = Calendar.current
                let year = calendar.component(.year, from: d)
                if year < 1910{
                    return false
                }
                return true
            }
        }
        else{
            return false
        }
    }
    
    public func setValidDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: bitrhday){
            self.bitrhday = dateFormatter.string(from: date)
            return dateFormatter.string(from: date)
        }else{
            self.bitrhday = dateFormatter.string(from: Date())
            return dateFormatter.string(from: Date())
        }
    }
    
    public func getDateInFormat(date: Date?) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = date{
            self.bitrhday = dateFormatter.string(from: date)
            return dateFormatter.string(from: date)
        }else{
            self.bitrhday = dateFormatter.string(from: Date())
            return dateFormatter.string(from: Date())
        }
    }
    
    func requestSendBirthday(callback: @escaping ((ResultResponce, ErrorResponce?) -> ())) {
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .sendBirthday(birthdate: bitrhday)) { (value) in
            if value?.isSuccess == true{
                AccountRequiredField.shared.removeField(at: .birthday)
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
            }
        }
    }
}
