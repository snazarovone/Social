//
//  HiddenNavBarNavigationController.swift
//  Eschty
//
//  Created by Aisana on 23.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class HiddenNavBarNavigationController: UINavigationController {
    
    //PUCLIC
    public var becomeTabBar: (()->())? = nil
        
    // MARK: - Properties
    
    private var popRecognizer: InteractivePopRecognizer?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopRecognizer()
        
    }
    
    // MARK: - Setup
    private func setupPopRecognizer() {
        popRecognizer = InteractivePopRecognizer(controller: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
 
    deinit {
        print("HiddenNavBarNavigationController is deinit")
    }
}
