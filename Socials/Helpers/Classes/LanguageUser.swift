//
//  LanguageUser.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

class LanguageUser: LanguageUserType{
    static var shared = LanguageUser()
    
    public var selectLanguge: LanguageAvailableList = .english
    
    init(){
        getCurrentLanguage()
    }
    
    private func getCurrentLanguage(){
        let languageCode = Locale.current.languageCode
        self.selectLanguge = getCurrentLanguage(with: languageCode)
    }
    
    private func getCurrentLanguage(with code: String?) -> LanguageAvailableList{
        for lan in LanguageAvailableList.allCases{
            if lan.code == code{
                return lan
            }
        }
        return .english
    }
}

enum LanguageAvailableList: CaseIterable{
    case english
    case russia
}

extension LanguageAvailableList{
    var code: String{
        switch self {
        case .english:
            return "en"
        case .russia:
            return "ru"
        }
    }
}
