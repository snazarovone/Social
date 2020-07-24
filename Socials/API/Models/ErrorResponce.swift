//
//  ErrorResponce.swift
//  Eschty
//
//  Created by Aisana on 25.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

enum ErrorResponce{
    case forbidden
    case detailError(message: String?, error: String?)
    case unauthorized
}

extension ErrorResponce{
    var error: String{
        switch self {
        case .forbidden:
            return "Forbidden"
        case .detailError(_, let error):
            return error ?? NSLocalizedString("Error", comment: "Alert title default")
        case .unauthorized:
            return "Unauthorized"
        }
    }
    
    var message: String{
        switch self {
        case .forbidden:
            return "Access Denied"
        case .detailError(let message, _):
            return message ?? ""
        case .unauthorized:
            return ""
        }
    }
    
    var statusCode: Int{
        switch self {
        case .forbidden:
            return 403
        case .detailError(_, _):
            return 99
        case .unauthorized:
            return 401
        }
    }
}
