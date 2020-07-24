//
//  SearchLocationViewModelType.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchLocationViewModelType {
    
    var input: String {get set}
    var selectLocIndex: IndexPath? {get}
    
    var addresses: BehaviorRelay<[AutocompleteAddress]> {get}
    var addressesLetter: BehaviorRelay<[AddressesLetter]> {get}
    
    func requestAutoCompleteAddress()
    
    func numberOfRow(in section: Int) -> Int
    func numberSection() -> Int
    func cellForRow(at indexPath: IndexPath) -> LocationCellViewModelType
    func didSelect(at indexPath: IndexPath)
    func getSelectedAutocomplete() -> AutocompleteAddress
    
    func titleHeader(at section: Int) -> String
    func selectValidField() -> Bool
    func clearDataSearch()
    
}
