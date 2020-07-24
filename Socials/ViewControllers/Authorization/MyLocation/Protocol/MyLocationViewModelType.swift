//
//  MyLocationViewModelType.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

protocol MyLocationViewModelType {
    
    var formatted_address: BehaviorRelay<String?> {get}
    var location: LocationGoogleModel? {get}
    
    func titleNeedTurnOnGeoLoc() -> NSMutableAttributedString
    func titleSearchAddress() -> NSMutableAttributedString
    func titleLocationNotFound() -> NSMutableAttributedString
    
    func requestLocations(by location: CLLocationCoordinate2D, callback: @escaping ((ResultResponce)->()))
    func requestPlaceDetail(by place_id: String, callback: @escaping (ResultResponce, PlaceDetailsModel?)->())
    func requestRegisterLocation(callback: @escaping ((ResultResponce, ErrorResponce?) -> ()))
}
