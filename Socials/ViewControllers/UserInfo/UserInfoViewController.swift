//
//  UserInfoViewController.swift
//  Jivys
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- deinit
    deinit {
        print("UserInfoViewController is deinit")
    }

}
