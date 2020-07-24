//
//  HandlerErrorType.swift
//  Eschty
//
//  Created by Aisana on 25.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

protocol HandlerErrorType {
    func accessDenied()
    func getMessage(at value: BaseResponseModel?) -> ErrorResponce?
}
