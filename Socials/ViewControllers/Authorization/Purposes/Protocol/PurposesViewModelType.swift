//
//  PurposesViewModelType.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol PurposesViewModelType {
    var purposes: BehaviorRelay<[Purpose]> {get}
    var code: String? {get}
    var search: String {get}
    
    
    func requestGetPurpose(code: String?, searchPhrase: String?, callback: @escaping ((ResultResponce, ErrorResponce?, Bool) -> ()))
    
    func numberOfRow() -> Int
    func cellForRow(at indexPath: IndexPath) -> PurposesCellViewModelType
    func didSelectCell(at indexPath: IndexPath) -> String?
}
