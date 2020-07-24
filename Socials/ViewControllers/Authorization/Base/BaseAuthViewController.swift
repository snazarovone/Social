//
//  BaseAuthViewController.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class BaseAuthViewController: UIViewController {
    
    private var baseAuthViewModel = BaseAuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Next ViewControler
    public func nextViewController(){
        print("VCID", self.baseAuthViewModel.fieldsRequired.value.first)
        guard let idVC = self.baseAuthViewModel.fieldsRequired.value.first?.idVC else{
            self.dismiss(animated: false) {
                (self.navigationController as! HiddenNavBarNavigationController).becomeTabBar?()
            }
            return
        }
        let st = UIStoryboard(name: "Authorization", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: idVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Alert
    public func alert(at title: String?, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action: UIAlertAction
        
        if AuthToken.shared.token != nil{
            action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        }else{
            action = UIAlertAction(title: "OK", style: .default) { (_) in
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //deinit
    deinit {
        print("BaseAuthViewController is deinit")
    }
    
}
