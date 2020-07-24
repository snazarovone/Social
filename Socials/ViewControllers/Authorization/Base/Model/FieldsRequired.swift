//
//  FieldsRequired.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
enum FieldsRequired: CaseIterable {
    case email
    case whoami
    case name
    case birthday
    case purpose
    case photos
    case location
}

extension FieldsRequired{
    var key: String{
        switch self {
        case .email:
            return "EMAIL"
        case .whoami:
            return "WHOAMI"
        case .name:
            return "NAME"
        case .birthday:
            return "BIRTH_DATE"
        case .purpose:
            return "PURPOSE"
        case .photos:
            return "PHOTOS"
        case .location:
            return "LOCATION"
        }
    }
    
    var idVC: String?{
        switch self {
        case .email:
            return String(describing: EmailViewController.self)
        case .whoami:
            return String(describing: WhomiViewController.self)
        case .name:
            return String(describing: NameViewController.self)
        case .birthday:
            return String(describing: BirthdayViewController.self)
        case .photos:
            return String(describing: MyPhotosViewController.self)
        case .location:
            return String(describing: MyLocationViewController.self)
        case .purpose:
            return String(describing: PurposesViewController.self)
        }
    }
}
