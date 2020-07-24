//
//  LocationCellViewModelType.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

protocol LocationCellViewModelType: class {
    
    var nameFormated: NSMutableAttributedString? {get}
    var isSelect: Bool {get}
}
