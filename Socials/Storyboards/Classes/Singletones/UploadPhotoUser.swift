//
//  UploadPhotoUser.swift
//  Jivys
//
//  Created by Aisana on 02.06.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

class UploadPhotoUser{

    static var shared = UploadPhotoUser()
    
    private func reqestS3ObjectKey(img: Data, callback: @escaping ((ResultResponce, ErrorResponce?) -> ())){
        AuthAPI.requstAuthAPI(type: S3ObjectKey.self, request: .uploadFileToS3(image: img)) { (value) in
            if value?.isSuccess == true, value?.s3ObjectKey != nil{
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
            }
        }
    }
}
