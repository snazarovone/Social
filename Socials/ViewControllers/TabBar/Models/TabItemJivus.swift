//
//  TabItemJivus.swift
//  Jivys
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import Foundation

enum TabItemJivus: CaseIterable {
    case settings
    case profile
    case search
    case matches
    case message
}

extension TabItemJivus{
    var index: Int{
        switch self {
        case .settings:
            return 0
        case .profile:
            return 1
        case .search:
            return 2
        case .matches:
            return 3
        case .message:
            return 4
        }
    }
}
