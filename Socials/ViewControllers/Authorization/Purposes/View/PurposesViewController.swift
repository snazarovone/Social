//
//  PurposesViewController.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import SwiftOverlays
import RxSwift
import RxCocoa

class PurposesViewController: BaseAuthViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var findTF: DesignableUITextField!
    
    @IBOutlet weak var topAlertConst: NSLayoutConstraint!
    @IBOutlet weak var viewAlert: DesignableUIViewEasy!
    @IBOutlet weak var searchBtn: DesignableUIButton!
    
    
    //PRIVATE
    private let purposeViewModel = PurposesViewModel()
    private let disposeBag = DisposeBag()
    
    private var tap: UITapGestureRecognizer!
    
    //PUBLIC
    public var isComplite: (()->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topAlertConst.constant = -viewAlert.frame.height
        viewAlert.shadowOpacity = 0.0
        view.layoutIfNeeded()
        
        isActiveNextBtn()
        
        configKeyboard()
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 44.0, right: 0.0)
        
        subscribes()
        requestGetPurpose(code: nil, searchPhrase: nil)
    }
    
    private func subscribes(){
        purposeViewModel.purposes.subscribe(onNext: { [weak self] (_) in
            self?.collectionView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK:- Helpers
    private func isActiveNextBtn(){
        if purposeViewModel.search.isEmpty == false{
            searchBtn.alpha = 1.0
            searchBtn.isEnabled = true
        }else{
            searchBtn.alpha = 0.6
            searchBtn.isEnabled = false
        }
    }
    
    //MARK:- Requests
    private func requestGetPurpose(code: String?, searchPhrase: String?){
        SwiftOverlays.showBlockingWaitOverlay()
        purposeViewModel.requestGetPurpose(code: code, searchPhrase: searchPhrase) { [weak self] (resultResponce, error, isTerminating) in
            switch resultResponce{
            case .success:
                if isTerminating{
                    //запоминаем выбор
                    self?.requestRegisterPurpose()
                }else{
                    SwiftOverlays.removeAllBlockingOverlays()
                }
            case .fail:
                SwiftOverlays.removeAllBlockingOverlays()
                self?.alert(at: error?.error ?? "", message: error?.message ?? "")
            }
        }
    }
    
    private func requestCreatePurpoce(){
        SwiftOverlays.showBlockingWaitOverlay()
        purposeViewModel.requestCreatePurpose { [weak self] (resultResponce, error) in
            SwiftOverlays.removeAllBlockingOverlays()
            
            self?.purposeViewModel.purposes.accept(self?.purposeViewModel.startPurposes.value ?? [])
            
            self?.findTF.text = nil
            self?.purposeViewModel.search = ""
            self?.purposeViewModel.code = nil
            
            switch resultResponce{
            case .success:
                self?.showHideAlert()
            case .fail:
                self?.alert(at: error?.error ?? "", message: error?.message ?? "")
            }
        }
    }
    
    private func requestRegisterPurpose(){
        purposeViewModel.requestRegisterPurpose { [weak self] (resultResponce, error) in
            SwiftOverlays.removeAllBlockingOverlays()
            
            switch resultResponce{
            case .success:
                if self?.navigationController != nil{
                    self?.nextViewController()
                }else{
                    self?.dismiss(animated: true, completion: {
                        self?.isComplite?()
                    })
                }
            case .fail:
                self?.alert(at: error?.error ?? "", message: error?.message ?? "")
            }
        }
    }
    
    
    private func showHideAlert(){
        var newConstraint: CGFloat = -20.0
        if topAlertConst.constant == newConstraint{
            //показать
            newConstraint = -viewAlert.frame.height
        }
        
        topAlertConst.constant = newConstraint
    
        if newConstraint == -20.0{
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                self.viewAlert.shadowOpacity = 1.0
            }) { (_) in
                self.viewAlert.shakeVerticle()
                self.showHideAlert()
            }
        }else{
            UIView.animate(withDuration: 0.5, delay: 3.5, options: .allowAnimatedContent, animations: {
                self.view.layoutIfNeeded()
                self.viewAlert.shadowOpacity = 0.0
            }, completion: nil)
        }
    }
    
    //MARK:- Actions
    @IBAction func back(_ sender: Any) {
        dismissKeyboard()
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func findAction(_ sender: Any) {
        dismissKeyboard()
        requestGetPurpose(code: nil, searchPhrase: purposeViewModel.search)
    }
    
    //MARK:- deinit
    deinit{
        print("PurposesViewController is deinit")
    }
}

//MARK:- UITextFieldDelegate
extension PurposesViewController: UITextFieldDelegate{
    fileprivate func configKeyboard(){
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.isEnabled = false
        //event свернуть клавиатуру если был тап в пустую область
        view.addGestureRecognizer(tap)
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
        isActiveNextBtn()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true}
        
        purposeViewModel.search = currentText
        isActiveNextBtn()
        
        if currentText.isEmpty{
            if purposeViewModel.numberOfRow() > 0{
                let code = purposeViewModel.didSelectCell(at: IndexPath(row: 0, section: 0))
                if code == "aisana_ios_create_goal"{
                    textField.text = currentText
                    dismissKeyboard()
                    requestGetPurpose(code: nil, searchPhrase: purposeViewModel.search)
                    return false
                }
            }
        }
        
        return true
    }
}

//MARK:- CollectionView
extension PurposesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purposeViewModel.numberOfRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PurposesCollectionViewCell.self), for: indexPath) as! PurposesCollectionViewCell
        cell.dataPurpose = purposeViewModel.cellForRow(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 0.2 * UIScreen.main.bounds.height
        
        var colomn: Int = 2
        if (indexPath.row + 1) % 3 == 1{
            colomn = 1
        }else{
            if (indexPath.row + 1) == purposeViewModel.purposes.value.count && (indexPath.row + 1) % 3 != 0{
                colomn = 1
            }
        }
        
        var width = (collectionView.frame.width / CGFloat(colomn))
        if colomn == 2{
            width -= 5
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let code = purposeViewModel.didSelectCell(at: indexPath)
        
        if code == "aisana_ios_create_goal"{
            requestCreatePurpoce()
        }else{
            requestGetPurpose(code: code, searchPhrase: nil)
        }
    }
}
