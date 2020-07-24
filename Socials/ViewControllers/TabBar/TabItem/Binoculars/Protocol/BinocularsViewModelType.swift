//
//  BinocularsViewModelType.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


protocol BinocularsViewModelType{
    var resultsUser: BehaviorRelay<[ItemResultModel]> {get set}
    var page: Int {get}
    var size: Int {get}
    
    var sizeImage: CGSize {get}
    
    var currentItem: BehaviorRelay<Int?> {get}
    var indexPhoto: Int {get set}
    
    var nameAndAge: String? {get}
    var miles: String? {get}
    var ofMatch: String? {get}
    var userID: String? {get}
    
    func numberOfItemsInSection() -> Int
    func cellForRow(at indexPath: IndexPath) -> BinocularsCellViewModelType
    func nextCurentItem() -> NextData
    func previousCurrentItem()
    func initNumberPages()
}
