//
//  ExtensionStackView.swift
//  Jivys
//
//  Created by Aisana on 11.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import UIKit

extension UIStackView {
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }

    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}
