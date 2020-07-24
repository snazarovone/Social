//
//  MyPhotosViewModelType.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyPhotosViewModelType {
    var photos: BehaviorRelay<[UIImage?]> {get}
    var currentPhoto: Int? {get set}
    
    func addPhoto(image: UIImage?)
    func isExistPhoto() -> Bool
    func sendPhotos(data: [Data], callback: @escaping ((ResultResponce, ErrorResponce?) -> ()))
    func getPhotoForSend() -> [Data]
    func getKeysForSend() -> [String]
    func sendPhotoKey(keys: [String], callback: @escaping ((ResultResponce, ErrorResponce?) -> ()))
}
