//
//  MyLocationViewModel.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MyLocationViewModel: MyLocationViewModelType{
    
    var formatted_address: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var location: LocationGoogleModel?
    
    init(){
    }
    
    func titleNeedTurnOnGeoLoc() -> NSMutableAttributedString{
        let text = NSLocalizedString("You need turn on location on this device\nto use our app", comment: "My location title")
       
        let line2 = NSLocalizedString("to use our app", comment: "My location title substring")
        
        let rangeFullText = NSString(string: text).range(of: text, options: String.CompareOptions.caseInsensitive)
        let rangeLine2 = NSString(string: text).range(of: line2, options: String.CompareOptions.caseInsensitive)
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1089999974, green: 0.2720000148, blue: 0.4589999914, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Medium", size: 14)!,
                                        NSAttributedString.Key.paragraphStyle: paragraphStyle], range: rangeFullText)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1089999974, green: 0.2720000148, blue: 0.4589999914, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Medium", size: 14)!], range: rangeLine2)
        return attributedString
    }
    
    func titleSearchAddress() -> NSMutableAttributedString{
        let textLocation = NSLocalizedString("Your location is", comment: "My Location title Your location is")
        let fullText = "\(textLocation) \(formatted_address.value ?? "")"
        
        let rangeFullText = NSString(string: fullText).range(of: fullText, options: String.CompareOptions.caseInsensitive)
        let rangeAddress = NSString(string: fullText).range(of: formatted_address.value ?? "", options: String.CompareOptions.caseInsensitive)
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1089999974, green: 0.2720000148, blue: 0.4589999914, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Semibold", size: 24)!,
                                        NSAttributedString.Key.paragraphStyle: paragraphStyle], range: rangeFullText)
   
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0.7820000052, blue: 0.7120000124, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Semibold", size: 24)!,
                                        NSAttributedString.Key.underlineStyle:
                                            NSUnderlineStyle.single.rawValue as Any,
                                        NSAttributedString.Key.underlineColor: #colorLiteral(red: 0, green: 0.7820000052, blue: 0.7120000124, alpha: 1)], range: rangeAddress)
        return attributedString
        
    }
    
    func titleLocationNotFound() -> NSMutableAttributedString{
        let text = NSLocalizedString("Location not found", comment: "Location not found")
        let rangeFullText = NSString(string: text).range(of: text, options: String.CompareOptions.caseInsensitive)
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1089999974, green: 0.2720000148, blue: 0.4589999914, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Semibold", size: 24)!,
                                        NSAttributedString.Key.paragraphStyle: paragraphStyle], range: rangeFullText)
        return attributedString
    }
    
    
    func requestLocations(by location: CLLocationCoordinate2D, callback: @escaping ((ResultResponce)->())){
        let latLng = convertLocation(location)
       
        reqestGetListAddresses(latLng) { [weak self] (resultResponce, googleResultAddress) in
            switch resultResponce{
            case .success:
                self?.requestPlaceDetail(by: googleResultAddress!.place_id!, callback: {
                    (resultResponce, placeDetailsModel) in
                    callback(resultResponce)
                })
            case .fail:
                callback(.fail)
            }
        }
        
    }
    
    private func convertLocation(_ location: CLLocationCoordinate2D) -> String{
        let lat = String(location.latitude)
        let lng = String(location.longitude)
        return "\(lat),\(lng)"
    }
    
    private func reqestGetListAddresses(_ latLng: String, callback: @escaping ((ResultResponce, GoogleResultAddress?)->())){
        GoogleAPI.requestGoogleAPI(type: AddressesList.self, request: .addressList(latlng: latLng)) { (value) in
            if let value = value, let results = value.results, let firstAddress = results.first,
                firstAddress.place_id != nil{
                callback(.success, firstAddress)
            }else{
                callback(.fail, nil)
            }
        }
    }
    
    func requestPlaceDetail(by place_id: String, callback: @escaping (ResultResponce, PlaceDetailsModel?)->()){
        GoogleAPI.requestGoogleAPI(type: PlaceDetailsModel.self, request: .placeDetails(place_id: place_id)) { [weak self] (value) in
            if let value = value, let result = value.result, result.formatted_address != nil,
                let geometry = result.geometry, let location = geometry.location,
                location.lng != nil, location.lat != nil{
                
                self?.formatted_address.accept(result.formatted_address)
                self?.location = location
                
                callback(.success, value)
            }else{
                callback(.fail, value)
            }
        }
    }
    
    func requestRegisterLocation(callback: @escaping ((ResultResponce, ErrorResponce?) -> ())){
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .registerLocation(formattedAddress: formatted_address.value ?? "", lat: location?.lat ?? 0.0, lng: location?.lng ?? 0.0), callback: { (value) in
            if value?.isSuccess == true{
                AccountRequiredField.shared.removeField(at: .location)
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
            }
        })
    }
}
