//
//  MyPhotosViewModel.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyPhotosViewModel: MyPhotosViewModelType{
    
    var photos: BehaviorRelay<[UIImage?]> = BehaviorRelay(value: [nil, nil, nil, nil, nil, nil, nil, nil])
    var imgURLs: BehaviorRelay<[String?]> = BehaviorRelay(value: [nil, nil, nil, nil, nil, nil, nil, nil])
    
    var currentPhoto: Int? = nil
    
    private var s3ObjectKey = [S3ObjectKey]()
    
    init() {
    }
    
    public func addPhoto(image: UIImage?){
        guard let currentPhoto = currentPhoto else{
            return
        }
        var tempPhoto = photos.value
        tempPhoto[currentPhoto] = image
        
        photos.accept(tempPhoto)
    }
    
    public func addUrlPhoto(url: String?){
        guard let currentPhoto = currentPhoto else{
            return
        }
        var tempImgURLs = imgURLs.value
        tempImgURLs[currentPhoto] = url
        
        imgURLs.accept(tempImgURLs)
    }
    
    public func isExistPhoto() -> Bool{
        for photo in photos.value{
            if photo != nil{
                return true
            }
        }
        return false
    }
    
    public func equalsPhoto() -> Bool{
        var count = 0
        for i in imgURLs.value{
            for j in imgURLs.value{
                if i != nil && i == j{
                    count += 1
                }
            }
            if count > 1{
                break
            }else{
                count = 0
            }
        }
        if count > 1{
            return true
        }else{
            return false
        }
    }
    
    func sendPhotos(data: [Data], callback: @escaping ((ResultResponce, ErrorResponce?) -> ())){
        var myData = data
        if let dataImg = myData.first{
            reqestS3ObjectKey(img: dataImg) { [weak self] (resultResponce, error) in
                switch resultResponce{
                case .success:
                    myData.removeFirst()
                    self?.sendPhotos(data: myData, callback: { (resultResponce, error) in
                        callback(resultResponce, error)
                    })
                case .fail:
                    callback(.fail, error)
                }
            }
        }else{
            callback(.success, nil)
        }
    }
    
    func getPhotoForSend() -> [Data]{
        var data = [Data]()
        for img in photos.value{
            if let img = img, let dataImg = img.jpegData(compressionQuality: 0.5){
                data.append(dataImg)
            }
        }
        return data
    }
    
    private func reqestS3ObjectKey(img: Data, callback: @escaping ((ResultResponce, ErrorResponce?) -> ())){
        AuthAPI.requstAuthAPI(type: S3ObjectKey.self, request: .uploadFileToS3(image: img)) { [weak self] (value) in
            if value?.isSuccess == true, value?.s3ObjectKey != nil{
                self?.s3ObjectKey.append(value!)
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
            }
        }
    }
    
    func getKeysForSend() -> [String]{
        var keys = [String]()
        for key in s3ObjectKey{
            if let k = key.s3ObjectKey{
                keys.append(k)
            }
        }
        return keys
    }
    
    func sendPhotoKey(keys: [String], callback: @escaping ((ResultResponce, ErrorResponce?) -> ())){
        var mYKeys = keys
        if let key = mYKeys.first{
            requestSendPhoto(key: key) { [weak self] (resultResponce, error) in
                switch resultResponce{
                case .success:
                    mYKeys.removeFirst()
                    self?.sendPhotoKey(keys: mYKeys, callback: { (resultResponce, error) in
                        callback(resultResponce, error)
                    })
                case .fail:
                    callback(.fail, error)
                }
            }
        }else{
            AccountRequiredField.shared.removeField(at: .photos)
            callback(.success, nil)
        }
    }
    
    private func requestSendPhoto(key: String, callback: @escaping ((ResultResponce, ErrorResponce?) -> ())){
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .registerPhotos(photosKey: key)) { (value) in
            if value?.isSuccess == true{
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
            }
        }
    }
}
