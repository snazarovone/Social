//
//  TipTwoViewController.swift
//  Jivys
//
//  Created by Sergey Nazarov on 11.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import UIKit

class TipTwoViewController: UIViewController {
    
    var isComplete: (()->())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        self.isComplete?()
    }
    
    deinit {
        print("TipTwoViewController is deinit")
    }
}
