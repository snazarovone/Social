//
//  AuthorizationViewModelType.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

protocol AuthorizationViewModelType {
    func nubmerOfRow() -> Int
    func cellFor(at indexPath: IndexPath) -> AuthorizationCellViewModelType
    func setValidDate(strDate: String?) -> String?
}
