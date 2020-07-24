//
//  TabBarJivysViewController.swift
//  Jivys
//
//  Created by Aisana on 04.06.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit

class TabBarJivysViewController: UITabBarController {
    
    var isAuth: (()->())? = nil
    
    var heightwithOutSafeArea: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 2
    }
    
    
    override func viewDidLayoutSubviews() {
        let guide = view.safeAreaLayoutGuide
        heightwithOutSafeArea = guide.layoutFrame.size.height
//
//        print(heightwithOutSafeArea)
//        print(view.frame.height)
//        if heightwithOutSafeArea + 20.0 == view.frame.height{
//            tabBar.frame = CGRect(x: 0, y: 48.0, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
//        }else{
        tabBar.frame = CGRect(x: 0, y: 32.0, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
//        }
        super.viewDidLayoutSubviews()
    }
}
