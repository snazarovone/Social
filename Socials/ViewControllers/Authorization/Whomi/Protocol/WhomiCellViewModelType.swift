//
//  WhomiCellViewModelType.swift
//  Eschty
//
//  Created by Aisana on 25.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

protocol WhomiCellViewModelType: class {
    var backgroundColor: UIColor {get}
    var shadowColor: UIColor? {get}
    var shadowBlur: CGFloat {get}
    var shadowOffSet: CGPoint {get}
    var shadowOpacity: Float {get}
    var hideCheckSelect: Bool {get}
    var name: String? {get}
}
