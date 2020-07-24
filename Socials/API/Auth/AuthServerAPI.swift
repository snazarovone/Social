//
//  AuthServerAPI.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum AuthServerAPI{
    case sendMobilePhone(mobilePhone: String)
    case confirmMobilePhone(code: String, mobilePhone: String, regToken: String?)
    case registerEmail(email: String)
    case getWhoamis
    case setWhoami(showWhoamiInProfile: Bool, whoami: String)
    case sendName(name: String)
    case sendBirthday(birthdate: String)
    case uploadFileToS3(image: Data)
    case registerPhotos(photosKey: String)
    case registerLocation(formattedAddress: String, lat: Double, lng: Double)
    case getPurposes(code: String?, searchPhrase: String?)
    case createPurpose(presentation: String)
    case registerPurpose(purposeCode: String)
    case oAuthRegistrationRequestDto(birthdate: String?, email: String?, name: String?, oauthProviderUserId: String, photoUrl: String?)
}

extension AuthServerAPI: TargetType{
    var baseURL: URL {
        return BaseUrl.url.value
    }
    
    var path: String {
        switch self {
        case .sendMobilePhone:
            return "register/mobile-phone"
        case .confirmMobilePhone:
            return "register/mobile-phone/confirm"
        case .registerEmail:
            return "register/email"
        case .getWhoamis:
            return "dictionaries/whoamis"
        case .setWhoami:
            return "register/whoami"
        case .sendName:
            return "register/name"
        case .sendBirthday:
            return "register/birthdate"
        case .uploadFileToS3:
            return "s3-files"
        case .registerPhotos:
            return "register/photos"
        case .registerLocation:
            return "register/location"
        case .getPurposes:
            return "dictionaries/purposes"
        case .createPurpose:
            return "dictionaries/purposes"
        case .registerPurpose:
            return "register/purpose"
        case .oAuthRegistrationRequestDto:
            return "register/oauth-reg-data"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendMobilePhone, .confirmMobilePhone, .registerEmail, .setWhoami, .sendName, .sendBirthday, .uploadFileToS3, .registerPhotos, .registerLocation, .createPurpose, .registerPurpose, .oAuthRegistrationRequestDto:
            return .post
        case .getWhoamis, .getPurposes:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .sendMobilePhone(let mobilePhone):
            return .requestParameters(parameters: ["mobilePhone": mobilePhone], encoding: JSONEncoding.default)
      
        case .confirmMobilePhone(let code, let mobilePhone, let regToken):
            var params: [String: String]
            params = ["code": code,
                      "mobilePhone": mobilePhone]
            if let regToken = regToken{
                params["regToken"] = regToken
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      
        case .registerEmail(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        
        case .getWhoamis:
            return .requestParameters(parameters: ["lang": "\(LanguageUser.shared.selectLanguge.code)"],
                                      encoding: URLEncoding.default)
       
        case .setWhoami(let showWhoamiInProfile, let whoami):
            return .requestParameters(parameters: ["showWhoamiInProfile": showWhoamiInProfile,
                                                   "whoami": whoami], encoding: JSONEncoding.default)
      
        case .sendName(let name):
            return .requestParameters(parameters: ["name": name], encoding: JSONEncoding.default)
            
        case .sendBirthday(let birthdate):
            return .requestParameters(parameters: ["birthdate" : birthdate], encoding: JSONEncoding.default)
       
        case .uploadFileToS3(let image):
            let data = MultipartFormData.init(provider: .data(image), name: "file", fileName: "img\(Date().timeIntervalSince1970)", mimeType: "image/jpeg")
            return .uploadMultipart([data])
            
        case .registerPhotos(let photosKey):
            return .requestParameters(parameters: ["photoS3ObjectKey": photosKey], encoding: JSONEncoding.default)
            
        case .registerLocation(let formattedAddress, let lat, let lng):
            return .requestParameters(parameters: ["formattedAddress" : formattedAddress,
                                                   "lat": lat,
                                                   "lng": lng], encoding: JSONEncoding.default)
      
        case .getPurposes(let code, let searchPhrase):
            var params = ["lang": LanguageUser.shared.selectLanguge.code]
           
            if let code = code{
                params["code"] = code
            }
            if let searchPhrase = searchPhrase{
                params["searchPhrase"] = searchPhrase
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
       
        case .createPurpose(let presentation):
            let params = ["lang": LanguageUser.shared.selectLanguge.code, "presentation": presentation]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .registerPurpose(let purposeCode):
            return .requestParameters(parameters: ["purposeCode": purposeCode], encoding: JSONEncoding.default)
            
        case .oAuthRegistrationRequestDto(let birthdate, let email, let name, let oauthProviderUserId, let photoUrl):
            var params = ["oauthProviderUserId": oauthProviderUserId]
            
            if let birthdate = birthdate{
                params["birthdate"] = birthdate
            }
            
            if let email = email{
                params["email"] = email
            }
            
            if let name = name{
                params["name"] = name
            }
            
            if let photoUrl = photoUrl{
                params["photoUrl"] = photoUrl
            }
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let params: [String: String]
        
        switch self {
        case .sendMobilePhone, .confirmMobilePhone, .oAuthRegistrationRequestDto:
            params = ["accept": "application/json",
                      "Accept-Language": "\(LanguageUser.shared.selectLanguge.code)",
                      "Content-Type": "application/json"]
        case .registerEmail, .setWhoami, .sendName, .sendBirthday, .registerPhotos, .registerLocation, .registerPurpose:
            params = ["X-Auth-Token": "\(AuthToken.shared.token ?? "")",
                      "accept": "application/json",
                      "Accept-Language": "\(LanguageUser.shared.selectLanguge.code)",
                      "Content-Type": "application/json"]
        case .getWhoamis, .getPurposes, .createPurpose:
            params = ["X-Auth-Token": "\(AuthToken.shared.token ?? "")",
                      "accept": "application/json",
                      "Accept-Language": "\(LanguageUser.shared.selectLanguge.code)"]
        case .uploadFileToS3:
            params = ["X-Auth-Token": "\(AuthToken.shared.token ?? "")",
                      "accept": "application/json",
                      "Accept-Language": "\(LanguageUser.shared.selectLanguge.code)",
                      "Content-Type": "multipart/form-data"]
        }
        return params
    }
    
}
