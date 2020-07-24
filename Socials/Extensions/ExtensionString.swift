//
//  ExtensionString.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

extension String{
    public func formattedPhoneNumber() -> String {
        let clearPhone = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XX-XX"
        
        var result = ""
        var index = clearPhone.startIndex
        for ch in mask where index < clearPhone.endIndex {
            if ch == "X" {
                result.append(clearPhone[index])
                index = clearPhone.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    public func formattedBirthday() -> String {
        let cleanDate = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXXX-XX-XX"
        
        var result = ""
        var index = cleanDate.startIndex
        for ch in mask where index < cleanDate.endIndex {
            if ch == "X" {
                result.append(cleanDate[index])
                index = cleanDate.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
//        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
//        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

         let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
         return emailPred.evaluate(with: self)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
