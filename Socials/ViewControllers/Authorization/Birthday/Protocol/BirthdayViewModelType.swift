//
//  BirthdayViewModelType.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

protocol BirthdayViewModelType {
    var bitrhday: String {get set}
    
    func validBithDate() -> Bool
    func getDateInFormat(date: Date?) -> String
    func setValidDate() -> String
    func requestSendBirthday(callback: @escaping ((ResultResponce, ErrorResponce?) -> ()))
}
