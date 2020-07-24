//
//  AddressesLetter.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import Foundation

class AddressesLetter{
    
    let addresses: [AutocompleteAddress]
    let letter: String
    
    init(at letter: String, addresses: [AutocompleteAddress]){
        self.addresses = addresses
        self.letter = letter
    }
}
