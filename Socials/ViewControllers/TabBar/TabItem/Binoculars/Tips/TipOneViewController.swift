//
//  TipOneViewController.swift
//  Jivys
//
//  Created by Aisana on 11.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import UIKit

class TipOneViewController: UIViewController {
    
    var isComplete: (()->())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        self.isComplete?()
    }
    
    deinit {
        print("TipOneViewController is deinit")
    }
}
