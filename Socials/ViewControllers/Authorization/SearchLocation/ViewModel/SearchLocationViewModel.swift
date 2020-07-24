//
//  SearchLocationViewModel.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchLocationViewModel: SearchLocationViewModelType{
    
    var input = ""
    var addresses: BehaviorRelay<[AutocompleteAddress]> = BehaviorRelay(value: [])
    var addressesLetter: BehaviorRelay<[AddressesLetter]> = BehaviorRelay(value: [])
    let disposeBag = DisposeBag()
    
    var selectLocIndex: IndexPath? = nil
    
    init() {
        subscribe()
    }
    
    private func subscribe(){
        addresses.subscribe(onNext: { [weak self] (value) in
            self?.sort(at: value)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    

    func requestAutoCompleteAddress(){
        GoogleAPI.requestGoogleAPI(type: PredictionsModel.self, request: .autocomplete(input: input)) { [weak self] (value) in
            self?.addresses.accept(value?.predictions ?? [])
        }
    }
    
    private func sort(at addresses: [AutocompleteAddress]){
        selectLocIndex = nil
        let sortedAddresses = addresses.sorted {
            if let l =  $0.description?.first, let r =  $1.description?.first{
                return  l < r
            }else{
                return false
            }
        }
        
        var addressesLetter = [AddressesLetter]()
        
        var header: String?
        var autocompleteAddress = [AutocompleteAddress]()
        
        for item in sortedAddresses{
            if let l = item.description, let firstCharter = l.first, item.place_id != nil{
                if String(firstCharter) != header{
                    if header != nil && autocompleteAddress.count > 0{
                        let a = AddressesLetter(at: header!, addresses: autocompleteAddress)
                        addressesLetter.append(a)
                        autocompleteAddress.removeAll()
                    }
                    header = String(firstCharter)
                    autocompleteAddress.append(item)
                }else{
                    autocompleteAddress.append(item)
                }
            }
        }
        if header != nil && autocompleteAddress.count > 0{
            let a = AddressesLetter(at: header!, addresses: autocompleteAddress)
            addressesLetter.append(a)
            autocompleteAddress.removeAll()
        }
        
        self.addressesLetter.accept(addressesLetter)
    }
    
    func numberSection() -> Int {
        return addressesLetter.value.count
    }
    
    func numberOfRow(in section: Int) -> Int {
        return addressesLetter.value[section].addresses.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> LocationCellViewModelType {
        var isSelect = false
        if let selectLocIndex = self.selectLocIndex,
            selectLocIndex.row == indexPath.row, selectLocIndex.section == indexPath.section{
            isSelect = true
        }
        
        return LocationCellViewModel(name: addressesLetter.value[indexPath.section].addresses[indexPath.row].description ?? "", inputText: self.input, isSelect: isSelect)
    }
    
    func didSelect(at indexPath: IndexPath) {
        self.selectLocIndex = indexPath
        self.addressesLetter.accept(self.addressesLetter.value)
    }
    
    func titleHeader(at section: Int) -> String{
        return addressesLetter.value[section].letter
    }
    
    func selectValidField() -> Bool{
        if let selectLocIndex = selectLocIndex,
            selectLocIndex.section < addressesLetter.value.count, selectLocIndex.row < addressesLetter.value[selectLocIndex.section].addresses.count{
            if addressesLetter.value[selectLocIndex.section].addresses[selectLocIndex.row].place_id != nil{
                return true
            }
            return false
        }else{
            return false
        }
    }
    
    func clearDataSearch(){
        selectLocIndex = nil
        addresses.accept([])
    }
    
    func getSelectedAutocomplete() -> AutocompleteAddress{
        return addressesLetter.value[selectLocIndex!.section].addresses[selectLocIndex!.row]
    }
}
