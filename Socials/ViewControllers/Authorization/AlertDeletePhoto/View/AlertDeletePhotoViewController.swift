//
//  AlertDeletePhotoViewController.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class AlertDeletePhotoViewController: UIViewController {
    
    @IBOutlet weak var alertView: DesignableUIViewEasy!
    
    //PUBLIC
    var isRemove: (()->())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.alpha = 0.0
        view.backgroundColor = UIColor(red:0.048, green:0.166, blue:0.354, alpha: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        alertView.alpha = 0.0
        self.view.backgroundColor = UIColor(red:0.048, green:0.166, blue:0.354, alpha: 0.0)
        UIView.animate(withDuration: 0.5) {
            self.alertView.alpha = 1.0
            self.view.backgroundColor = UIColor(red:0.048, green:0.166, blue:0.354, alpha: 0.5)
        }
    }
    
    @IBAction func yes(_ sender: Any) {
        self.alertView.alpha = 1.0
        self.view.backgroundColor = UIColor(red:0.048, green:0.166, blue:0.354, alpha: 0.5)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 0.0
            self.view.backgroundColor =  UIColor(red:0.048, green:0.166, blue:0.354, alpha: 0.0)
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
            self.isRemove?()
        }
    }
    
    
    @IBAction func no(_ sender: Any) {
        self.alertView.alpha = 1.0
        self.view.backgroundColor = UIColor(red:0.048, green:0.166, blue:0.354, alpha: 0.5)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 0.0
            self.view.backgroundColor =  UIColor(red:0.048, green:0.166, blue:0.354, alpha: 0.0)
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //MARK:- deinit
    deinit {
        print("AlertDeletePhotoViewController is deinit")
    }

}
