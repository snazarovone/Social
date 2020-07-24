//
//  BaseItemsViewController.swift
//  Jivys
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import UIKit

class BaseItemsViewController: UIViewController {
    
    private let widthSelectViewTabBar: CGFloat = 15.0
    private(set) lazy var facebookAuth = FacebookAuthService()
    
    public func getPositionItemBinocle(item: TabItemJivus) -> CGFloat{
        if let view = tabBarController?.tabBar.items?[item.index].value(forKey: "view") as? UIView{
            return view.center.x - widthSelectViewTabBar
        }
        return 0.0
    }
    
    public func colorsSearch(){
        guard let tabBar = tabBarController?.tabBar else {
            return
        }
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.5568627451, green: 0.6196078431, blue: 0.7647058824, alpha: 1)
    }
    
    public func colorsAddGoals(){
        guard let tabBar = tabBarController?.tabBar else {
            return
        }
        tabBar.tintColor = #colorLiteral(red: 0.1089999974, green: 0.2720000148, blue: 0.4589999914, alpha: 1)
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.8470588235, green: 0.8862745098, blue: 0.9294117647, alpha: 1)
    }
    
    //MARK:- Logout
    public func logout(){
        facebookAuth.logout()
        AuthToken.shared.removeToken()
        
        dismiss(animated: true) {
            if let mainVC = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController{
                mainVC.checkAuth()
            }
        }
    }
    
    public func showAlert(title: String?, message: String?, callBack: @escaping ()->()){
        guard title != nil || message != nil else{
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            callBack()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- deinit
    deinit{
        print("BaseItemsViewController is deinit")
    }
}
