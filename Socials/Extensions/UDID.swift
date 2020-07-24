//
//  UDID.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

enum UDID {
    case token
    case tokenComplite
    case isFirstStartApp
}

extension UDID{
    var key: String{
        switch self {
        case .token:
            return "token"
        case .tokenComplite:
            return "tokenComplite"
        case .isFirstStartApp:
            return "isFirstStartApp"
        }
    }
}
