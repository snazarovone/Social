//
//  UserViewController.swift
//  Jivys
//
//  Created by Aisana on 04.06.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideNavigationBar()
    }
    
    
    //MARK:- deinit
    deinit{
        print("UserViewController is deinit")
    }
}
