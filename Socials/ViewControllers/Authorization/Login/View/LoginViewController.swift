//
//  LoginViewController.swift
//  Eschty
//
//  Created by Aisana on 23.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import SwiftOverlays

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    //PRIVATE
    private var tap: UITapGestureRecognizer!
    
    //PUBLIC
    public var loginViewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isActiveNextBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissKeyboard()
        removeNotificationKeyBoard()
    }
    
    //MARK:- Helpers
    private func isActiveNextBtn(){
        if loginViewModel.phone.count > 7{
            nextBtn.alpha = 1.0
            nextBtn.isEnabled = true
        }else{
            nextBtn.alpha = 0.6
            nextBtn.isEnabled = false
        }
    }
    
    private func alert(message: String){
        let title = NSLocalizedString("Error", comment: "Alert title")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Request
    private func requestSendPhone(){
        SwiftOverlays.showBlockingWaitOverlay()
        loginViewModel.requestSendMobilePhone { [weak self] (resultResponce, baseResponseModel) in
            SwiftOverlays.removeAllBlockingOverlays()
            switch resultResponce{
            case .success:
                self?.performSegue(withIdentifier: String(describing: VerifyPhoneViewController.self), sender: nil)
            case .fail:
                self?.alert(message: baseResponseModel?.errorDetails ?? "")
            }
        }
    }
    
    //MARK:- Perform
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if String(describing: VerifyPhoneViewController.self) == segue.identifier{
            if let dvc = segue.destination as? VerifyPhoneViewController{
                dvc.varifyViewModel = VerifyPhoneViewModel(phone: loginViewModel.phone, regToken: loginViewModel.regToken)
            }
            return
        }
    }
    
    // MARK: - Actions
    @IBAction func back(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: UIButton){
        dismissKeyboard()
        requestSendPhone()
    }
    
    
    //MARK: - deinit
    deinit {
        print("LoginViewController is deinit")
    }
}

//MARK:- TextFiled Delegate
extension LoginViewController: UITextFieldDelegate{
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
//        startPhone(textField: textField)
        isActiveNextBtn()
    }
    
//    private func startPhone(textField: UITextField){
//        if loginViewModel.phone.isEmpty || loginViewModel.phone == "+"{
//            textField.text = "7".formattedPhoneNumber()
//
//            DispatchQueue.main.async {
//                let newPosition = textField.endOfDocument
//                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
//            }
//        }
//    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true}
        
        if currentText.count <= 18{
            loginViewModel.phone = currentText
            phoneNumber.text = loginViewModel.phone
        }
        isActiveNextBtn()
        
        return false
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
