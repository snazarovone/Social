//
//  MainViewController.swift
//  Eschty
//
//  Created by Aisana on 23.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.checkAuth()
        }
    }
    
    //MARK:- Helpers
    public func checkAuth(){
        if AuthToken.shared.tokenComplite == nil{
            self.performSegue(withIdentifier: String(describing: HiddenNavBarNavigationController.self), sender: nil)
        }else{
            self.performSegue(withIdentifier: String(describing: TabBarJivysViewController.self), sender: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: HiddenNavBarNavigationController.self){
            if let dvc = segue.destination as? HiddenNavBarNavigationController{
                dvc.becomeTabBar = {
                    [weak self] in
                    AuthToken.shared.setTokenComplete()
                    self?.performSegue(withIdentifier: String(describing: TabBarJivysViewController.self), sender: nil)
                }
            }
        }
        
        if segue.identifier == String(describing: TabBarJivysViewController.self){
            if let dvc = segue.destination as? TabBarJivysViewController{
                dvc.isAuth = {
                    [weak self] in
                    self?.checkAuth()
                }
            }
        }
    }
    //MARK:- deinit
    deinit {
        print("MainViewController is deinit")
    }
    
}
