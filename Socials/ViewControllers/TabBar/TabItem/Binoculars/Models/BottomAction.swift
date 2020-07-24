//
//  BottomAction.swift
//  Jivys
//
//  Created by Aisana on 11.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import Foundation

enum BottomAction: CaseIterable {
    case returnAction
    case like
    case superLike
    case dislike
}

extension BottomAction{
    var type: String{
        switch self {
        case .like:
            return "LIKE"
        case .dislike:
            return "DISLIKE"
        case .superLike:
            return "SUPER_LIKE"
        case .returnAction:
            return ""
        }
    }
    
    var tag: Int{
        switch self {
        case .returnAction:
            return 0
        case .like:
            return 1
        case .superLike:
            return 2
        case .dislike:
            return 3
        }
    }
}
