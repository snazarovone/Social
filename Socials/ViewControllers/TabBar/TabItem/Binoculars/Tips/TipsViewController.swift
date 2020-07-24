//
//  TipsViewController.swift
//  Jivys
//
//  Created by Sergey Nazarov on 11.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tipOne: UIView!
    @IBOutlet weak var tipTwo: UIView!
    
    @IBOutlet weak var topView: NSLayoutConstraint!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var viewMatch: UIView!
    @IBOutlet weak var mathcIcon: UIImageView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var matchValue: String?
    var topValue: CGFloat = 209.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.constant = topValue
        matchLabel.text = matchValue
        matchLabel.isHidden = true
        viewMatch.isHidden = true
        mathcIcon.isHidden = true
        tapGesture.isEnabled = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.alpha = 0.0
        
        tipOne.alpha = 0.0
        tipTwo.alpha = 0.0
        
        tipOne.isHidden = false
        tipTwo.isHidden = true
        
        UIView.animate(withDuration: 0.5) {
            self.tipOne.alpha = 1.0
            self.mainView.alpha = 1.0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: TipOneViewController.self), let dvc = segue.destination as? TipOneViewController{
            dvc.isComplete = {
                [weak self] in
                
                self?.tipOne.alpha = 1.0
                
                UIView.animate(withDuration: 0.5, animations: {
                    self?.tipOne.alpha = 0.0
                }) { (_) in
                    self?.tipTwo.alpha = 0.0
                    self?.tipOne.isHidden = true
                    self?.tipTwo.isHidden = false
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self?.tipTwo.alpha = 1.0
                    }, completion: nil)
                }
            }
            return
        }
        
        if segue.identifier == String(describing: TipTwoViewController.self), let dvc = segue.destination as? TipTwoViewController{
            dvc.isComplete = {
                [weak self] in
                
                self?.tipTwo.alpha = 1.0
                UIView.animate(withDuration: 0.5, animations: {
                    self?.tipTwo.alpha = 0.0
                }) { (_) in
                    
                    self?.matchLabel.alpha = 0
                    self?.viewMatch.alpha = 0
                    self?.mathcIcon.alpha = 0
                    
                    
                    self?.matchLabel.isHidden = false
                    self?.viewMatch.isHidden = false
                    self?.mathcIcon.isHidden = false
                    self?.tapGesture.isEnabled = true
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self?.matchLabel.alpha = 1.0
                        self?.viewMatch.alpha = 1.0
                        self?.mathcIcon.alpha = 1.0
                    }, completion: nil)
                    
                }
            }
            return
        }
        
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: {
            self.matchLabel.alpha = 0.0
            self.viewMatch.alpha = 0.0
            self.mathcIcon.alpha = 0.0
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    deinit{
        print("TipsViewController is deinit")
    }
    
}
