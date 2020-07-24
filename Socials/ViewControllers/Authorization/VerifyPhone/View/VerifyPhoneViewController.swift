//
//  VerifyPhoneViewController.swift
//  Eschty
//
//  Created by Aisana on 23.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import SwiftOverlays

class VerifyPhoneViewController: BaseAuthViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet var OTPTxtFields: [CodeTextField]!
    @IBOutlet var OTPViews: [DesignableUIViewEasy]!
    
    //PUBLIC
    public var varifyViewModel: VerifyPhoneViewModel!
    
    //PRIVATE
    private var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionLabel.attributedText = varifyViewModel.instruction
        
        OTPTxtFields.forEach {
            $0.myTextFieldDelegate = self
        }
        
        configKeyboard()
    }
    
    //MARK:- Request
    private func requestCheckCode(){
        SwiftOverlays.showBlockingWaitOverlay()
        varifyViewModel.requestCheckCode { [weak self] (resultResponce) in
            SwiftOverlays.removeAllBlockingOverlays()
            switch resultResponce{
            case .success:
                self?.nextViewController()
            case .fail:
                self?.OTPViews.first?.superview?.shake()
            }
        }
    }
    
    private func checkCode(){
        var texts:  [String] = []
        OTPTxtFields.forEach {  texts.append($0.text!)}
        let currentText = texts.reduce("", +)
        
        varifyViewModel.code = currentText
       
        if currentText.count == 4{
            //MARK:- CheckCode
            requestCheckCode()
        }else{
            self.OTPViews.first?.superview?.shake()
        }
    }
    
    //MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - Actions
    @IBAction func back(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func comfirm(_ sender: DesignableUIButton) {
        checkCode()
    }
    
    @IBAction func resend(_ sender: Any) {
        dismissKeyboard()
        OTPTxtFields.forEach {
            $0.text = nil
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissKeyboard()
        removeNotificationKeyBoard()
    }
    
    // MARK: - deinit
    deinit {
        print("VerifyPhoneViewController is deinit")
    }
    
}

//MARK:- TextField Delegate
extension VerifyPhoneViewController: UITextFieldDelegate, CodeTextFieldDelegate{
    fileprivate func configKeyboard(){
        //dissmis keyboard
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.isEnabled = false
        
        //event свернуть клавиатуру если был тап в пустую область
        view.addGestureRecognizer(tap)
        registerForKeyboardNotification()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        tap.isEnabled = false
        selectField(textField: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tap.isEnabled = true
        selectField(textField: textField)
    }
    
    private func selectField(textField: UITextField?){
        let tag = textField?.tag
        OTPViews.forEach { (v) in
            if v.tag == tag{
                v.borderC = #colorLiteral(red: 0, green: 0.7820000052, blue: 0.7120000124, alpha: 1)
                v.backgroundColor = .clear
                v.shadowColor = #colorLiteral(red: 0.8450000286, green: 0.9049999714, blue: 0.9480000138, alpha: 1)
                v.shadowBlur = 50.0
                v.shadowOffset = CGPoint(x: 0, y: 12)
                v.shadowOpacity = 0.6
            }else{
                v.borderC = #colorLiteral(red: 0.8550000191, green: 0.9200000167, blue: 0.9639999866, alpha: 1)
                v.backgroundColor = .clear
                v.shadowColor = nil
                v.shadowBlur = 0.0
                v.shadowOffset = CGPoint(x: 0, y: 0)
                v.shadowOpacity = 0.0
            }
        }
    }
    
    func textFieldDidEnterBackspace(_ textField: CodeTextField) {
        guard let index = OTPTxtFields.firstIndex(of: textField) else {
            return
        }
        
        if index > 0 {
            OTPTxtFields[index - 1].becomeFirstResponder()
            OTPTxtFields[index - 1].text = ""
        } else {
            dismissKeyboard()
        }
    }
    
    func callOTPValidate(){
        var texts:  [String] = []
        OTPTxtFields.forEach {  texts.append($0.text!)}
        sentOTPOption(currentText: texts.reduce("", +))
    }
    
    func sentOTPOption(currentText: String){
        dismissKeyboard()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        
        
        if newString.count < 2 && !newString.isEmpty {
            textFieldShouldReturnSingle(textField, newString : newString)
            //  return false
        }else{
            if newString.count == 2{
                newString = string
                textFieldShouldReturnSingle(textField, newString : newString)
            }
        }
        
        return newString.count < 2 || string == ""
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturnSingle(_ textField: UITextField, newString : String)
    {
        let nextTag: Int = textField.tag + 1
        textField.text = newString
        let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)?.subviews.first
        if let nextR = nextResponder
        {
            // Found next responder, so set it.
            nextR.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            callOTPValidate()
        }
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
