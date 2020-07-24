//
//  WhomiViewModelType.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol WhomiViewModelType {
    
    var whomiAllList: BehaviorRelay<[Whoami]> {get}
    var whomiList: BehaviorRelay<[Whoami]> {get}
    var isSelect: BehaviorRelay<Int?> {get}
    var isGender: Bool {get}
    
    func numberOfRow() -> Int
    func cellForRow(at indexPath: IndexPath) -> WhomiCellViewModelType
    func didSelect(at indexPath: IndexPath)
    
    func requestGetListWhomi(callback: @escaping ((ResultResponce, ErrorResponce?)->()))
    func requestSetWhomi(callback: @escaping ((ResultResponce, ErrorResponce?)->()))
    func getShowListWhomi()
    func getTitleOptionBtn() -> NSMutableAttributedString
}
