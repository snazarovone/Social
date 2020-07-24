//
//  AddGoalsViewController.swift
//  Jivys
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import UIKit

class AddGoalsViewController: UIViewController {
    
    @IBOutlet weak var leadingSelectedItem: NSLayoutConstraint!
   
    public var selectedItemPosition: CGFloat = 0.0
    public var updateResultsUser: (()->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leadingSelectedItem.constant = selectedItemPosition
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: PurposesViewController.self), let dvc = segue.destination as? PurposesViewController{
            dvc.isComplite = updateResultsUser
        }
    }
    
    //MARK:- Actions
    @IBAction func addGoals(_ sender: Any) {
        self.performSegue(withIdentifier: String(describing: PurposesViewController.self), sender: nil)
    }
    
    //MARK:- deinit
    deinit {
        print("AddGoalsViewController is deinit")
    }

}
