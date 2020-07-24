//
//  PurposesViewModel.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PurposesViewModel: PurposesViewModelType{
    
    var purposes: BehaviorRelay<[Purpose]> = BehaviorRelay(value: [])
    var startPurposes: BehaviorRelay<[Purpose]> = BehaviorRelay(value: [])
    
    var code: String? = nil
    var search: String = ""
    var newPurpose: String = ""
    
    init(){
    }
    
    func requestGetPurpose(code: String?, searchPhrase: String?, callback: @escaping ((ResultResponce, ErrorResponce?, Bool) -> ())){
        AuthAPI.requstAuthAPI(type: PurposesModel.self, request: .getPurposes(code: code, searchPhrase: searchPhrase), callback: { [weak self] (value) in
            if value?.isSuccess == true{
                if value?.items?.count != 0{
                    self?.purposes.accept(value?.items ?? [])
                    
                    if self?.startPurposes.value.count == 0{
                        //после создания цели показать все цели
                        self?.startPurposes.accept(value?.items ?? [])
                    }
                    
                    callback(.success, nil, false)
                }else{
                    if searchPhrase == nil{
                        callback(.success, nil, true)
                    }else{
                        //найдено 0 элементов по поиску предлагаем создать цель
                        let presentation = NSLocalizedString("Make your own goal", comment: "Make your own goal")
                        let p = Purpose(code: "aisana_ios_create_goal", presentation: presentation)
                        self?.newPurpose = searchPhrase ?? ""
                        self?.purposes.accept([p])
                        callback(.success, nil, false)
                    }
                }
            }else{
                self?.purposes.accept([])
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce, false)
            }
        })
    }
    
    func requestCreatePurpose(callback: @escaping ((ResultResponce, ErrorResponce?) -> ())){
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .createPurpose(presentation: newPurpose)) { (value) in
            if value?.isSuccess == true{
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
            }
        }
    }
    
    func requestRegisterPurpose(callback: @escaping ((ResultResponce, ErrorResponce?) -> ())) {
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .registerPurpose(purposeCode: code ?? "")) { (value) in
            if value?.isSuccess == true{
                AccountRequiredField.shared.removeField(at: .purpose)
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
            }
        }
    }
    
    func numberOfRow() -> Int {
        return purposes.value.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> PurposesCellViewModelType {
        return PurposesCellViewModel(purpose: purposes.value[indexPath.row])
    }
    
    func didSelectCell(at indexPath: IndexPath) -> String?{
        self.code = purposes.value[indexPath.row].code
        return code
    }
}
