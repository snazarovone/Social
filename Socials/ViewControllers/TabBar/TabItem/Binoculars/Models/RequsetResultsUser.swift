//
//  RequsetResultsUser.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import Foundation

class RequsetResultsUser{
    static func requestResultsUsers(at page: Int, size: Int, callback: @escaping (ResultResponce, ResultsUsersData?)->()){
        ResultsUsersAPI.requstResultsUserAPI(type: ResultsUsersData.self, request: .results(page: page, size: size)) { (value) in
            if value?.isSuccess == true{
                callback(.success, value)
            }else{
                callback(.fail, value)
            }
        }
    }
    
    static func requestLike(at userID: String, likeType: BottomAction){
        ResultsUsersAPI.requstResultsUserAPI(type: BaseResponseModel.self, request: .likes(userId: userID, type: likeType)) { (_) in
        }
    }
}
