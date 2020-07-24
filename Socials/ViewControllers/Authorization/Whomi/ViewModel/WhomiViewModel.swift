//
//  WhomiViewModel.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WhomiViewModel: WhomiViewModelType{
    
    var whomiAllList: BehaviorRelay<[Whoami]> = BehaviorRelay(value: [])
    var whomiList: BehaviorRelay<[Whoami]> = BehaviorRelay(value: [])
  
    var isMore: Bool = false
    var isSelect: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    var isGender = false
    
    init(){
    }
    
    //MARK:- Requests
    public func requestGetListWhomi(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        AuthAPI.requstAuthAPI(type: WhoamisModel.self, request: .getWhoamis) { [weak self] (value) in
            if value?.isSuccess == true{
                self?.whomiAllList.accept(value?.items ?? [])
                self?.getShowListWhomi()
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
            }
        }
    }
    
    public func requestSetWhomi(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        guard let isSelect = isSelect.value, isSelect < whomiList.value.count, let whomiCode = whomiList.value[isSelect].code else{
            callback(.fail, nil)
            return
        }
        
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .setWhoami(showWhoamiInProfile: isGender, whoami: whomiCode)) { (value) in
            if value?.isSuccess == true{
                AccountRequiredField.shared.removeField(at: .whoami)
                callback(.success, nil)
            }else{
                let errorResponce = HandlerError.shared.getMessage(at: value)
                callback(.fail, errorResponce)
            }
        }
    }
    
    func getShowListWhomi(){
        var tempList = [Whoami]()
        if isMore == false{
            for w in whomiAllList.value{
                if let code = w.code?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(){
                    if code == "WOMAN" || code == "MAN" || code == "COUPLE"{
                        tempList.append(w)
                    }
                }
            }
        }else{
            for w in whomiAllList.value{
//                if let code = w.code?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(){
//                    if code != "WOMAN" && code != "MAN" && code != "COUPLE"{
                        tempList.append(w)
//                    }
//                }
            }
        }
        whomiList.accept(tempList)
    }
    
    func getTitleOptionBtn() -> NSMutableAttributedString{
        let text: String
      
        if isMore == false{
            text = NSLocalizedString("More options", comment: "More options Button")
        }else{
            text = NSLocalizedString("Less options", comment: "Less options Button")
        }
        
        let rangeFullText = NSString(string: text).range(of: text, options: String.CompareOptions.caseInsensitive)
       
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0.7820000052, blue: 0.7120000124, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Regular", size: 14)!,
                                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue as Any], range: rangeFullText)
        return attributedString
    }
    
    func numberOfRow() -> Int {
        return whomiList.value.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> WhomiCellViewModelType {
        var select: Bool = false
        if let isSelect = self.isSelect.value, isSelect == indexPath.row{
            select = true
        }
        return WhomiCellViewModel(isSelect: select, whoami: whomiList.value[indexPath.row])
    }
    
    func didSelect(at indexPath: IndexPath) {
        self.isSelect.accept(indexPath.row)
        whomiList.accept(whomiList.value)
    }
}
