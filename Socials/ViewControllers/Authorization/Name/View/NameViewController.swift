//
//  NameViewController.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import SwiftOverlays

class NameViewController: BaseAuthViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextBtn: DesignableUIButton!
    
    //PRIVATE
    private let nameViewModel = NameViewModel()
    private var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configKeyboard()
        
        isActiveNextBtn()
    }
    
    //MARK:- Helpers
    private func isActiveNextBtn(){
        if nameViewModel.isValidName() == true{
            nextBtn.alpha = 1.0
            nextBtn.isEnabled = true
        }else{
            nextBtn.alpha = 0.6
            nextBtn.isEnabled = false
        }
    }
    
    //MARK:- Request
    private func requestSendName(){
        SwiftOverlays.showBlockingWaitOverlay()
        nameViewModel.requestSendName { [weak self] (resultResponce, error) in
            SwiftOverlays.removeAllBlockingOverlays()
            switch resultResponce{
            case .success:
                self?.nextViewController()
            case .fail:
                self?.alert(at: error?.error ?? "", message: error?.message ?? "")
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func next(_ sender: UIButton) {
        requestSendName()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissKeyboard()
        removeNotificationKeyBoard()
    }
    
    //MARK:- deinit
    deinit {
        print("NameViewController is deinit")
    }
}

//MARK:- UITextField
extension NameViewController: UITextFieldDelegate{
    fileprivate func configKeyboard(){
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.isEnabled = false
        //event свернуть клавиатуру если был тап в пустую область
        view.addGestureRecognizer(tap)
        registerForKeyboardNotification()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        tap.isEnabled = false
        isActiveNextBtn()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tap.isEnabled = true
        isActiveNextBtn()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true}
        
        nameViewModel.name = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        isActiveNextBtn()
        return true
    }
    
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification){
        let userInfo = notification.userInfo!
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        
        
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { [weak self] in
                        if let self = self{
                            self.view.layoutIfNeeded()
                        }
            },
                       completion: { (_) in
        })
    }
    
    @objc func kbWillHide(_ notification: Notification){
        let userInfo = notification.userInfo!
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentInset =  UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { [weak self] in
                        if let self = self{
                            self.view.layoutIfNeeded()
                        }
            },
                       completion: { (_) in
        })
    }
    
    func removeNotificationKeyBoard(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
}
