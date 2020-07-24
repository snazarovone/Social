//
//  SearchLocationViewController.swift
//  Jivys
//
//  Created by Aisana on 28.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchLocationViewController: UIViewController {
    
    @IBOutlet weak var searchTF: DesignableUITextField!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var confirmBtn: DesignableUIButton!
    
    //PRIVATE
    private let searchLocationViewModel = SearchLocationViewModel()
    private var tap: UITapGestureRecognizer!
    
    //PUBLIC
    public var isConfirmData: ((AutocompleteAddress)->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        configKeyboard()
        
        tableVIew.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 155.0, right: 0.0)
    }
    
    private func subscribe(){
        searchLocationViewModel.addressesLetter.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.tableVIew.reloadData()
            self?.isActiveNextBtn()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: searchLocationViewModel.disposeBag)
    }
    
    //MARK:- Helpers
    private func isActiveNextBtn(){
        if searchLocationViewModel.selectValidField(){
            confirmBtn.alpha = 1.0
            confirmBtn.isEnabled = true
        }else{
            confirmBtn.alpha = 0.6
            confirmBtn.isEnabled = false
        }
    }
    
    //MARK:- Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search(_ sender: UIButton) {
        searchTF.becomeFirstResponder()
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        isConfirmData?(searchLocationViewModel.getSelectedAutocomplete())
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- deinit
    deinit{
        print("SearchLocationViewController is deinit")
    }
}

//MARK:- TextField
extension SearchLocationViewController: UITextFieldDelegate{
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
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true}
        
        searchLocationViewModel.input = currentText
        if currentText.count >= 3{
            self.searchLocationViewModel.requestAutoCompleteAddress()
        }else{
            self.searchLocationViewModel.clearDataSearch()
        }
        
        return true
    }
}

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchLocationViewModel.numberSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchLocationViewModel.numberOfRow(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LocationTableViewCell.self)) as! LocationTableViewCell
        cell.dataLocation = searchLocationViewModel.cellForRow(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchLocationViewModel.didSelect(at: indexPath)
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.viewFromNibName(name: "LocationHeader") as! LocationHeaderView
        header.headerName.text = searchLocationViewModel.titleHeader(at: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
}
