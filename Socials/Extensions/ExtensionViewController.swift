//
//  ExtensionViewController.swift
//  Eschty
//
//  Created by Aisana on 23.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

extension UIViewController{
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
