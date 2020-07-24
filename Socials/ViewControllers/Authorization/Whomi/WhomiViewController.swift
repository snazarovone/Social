//
//  WhomiViewController.swift
//  Eschty
//
//  Created by Aisana on 24.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import SwiftOverlays
import RxSwift
import RxCocoa

class WhomiViewController: BaseAuthViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var genderBtn: UIButton!
    
    //PRIVATE
    private var whomiViewModel = WhomiViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribes()
        
        self.optionBtn.setAttributedTitle(self.whomiViewModel.getTitleOptionBtn(), for: .normal)
        
        toogleGender()
        
        requestGetListWhoami()
        
    }
    
    private func subscribes(){
        whomiViewModel.whomiList.asObservable().subscribe(onNext: { [weak self] (_) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        whomiViewModel.isSelect.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.isActiveNextBtn()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK:- Helpers
    private func isActiveNextBtn(){
        if whomiViewModel.isSelect.value != nil{
            nextBtn.alpha = 1.0
            nextBtn.isEnabled = true
        }else{
            nextBtn.alpha = 0.6
            nextBtn.isEnabled = false
        }
    }
    
    private func toogleGender(){
        if whomiViewModel.isGender{
            genderBtn.setImage(#imageLiteral(resourceName: "Check yes"), for: .normal)
        }else{
            genderBtn.setImage(nil, for: .normal)
        }
    }
    
    
    //MARK:- Requests
    private func requestGetListWhoami(){
        showWaitOverlay()
        whomiViewModel.requestGetListWhomi { [weak self] (resultResponce, error) in
            self?.removeAllOverlays()
            switch resultResponce{
            case .success:
                self?.tableView.reloadData()
                break;
            case .fail:
                self?.alert(at: error?.error ?? "", message: error?.message ?? "")
            }
        }
    }
    
    private func requestSetWhoami(){
        SwiftOverlays.showBlockingWaitOverlay()
        whomiViewModel.requestSetWhomi { [weak self] (resultResponce, error) in
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
    @IBAction func back(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func next(_ sender: UIButton) {
        requestSetWhoami()
    }
    
    @IBAction func options(_ sender: UIButton) {
        whomiViewModel.isMore.toggle()
        sender.isHidden = true
        whomiViewModel.getShowListWhomi()
    }
    
    @IBAction func isShowMyGender(_ sender: UIButton) {
        whomiViewModel.isGender.toggle()
        toogleGender()
    }
    
    //MARK:- deinit
    deinit {
        print("WhomiViewController is deinit")
    }

}

//MARK:- TableView
extension WhomiViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whomiViewModel.numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WhomiTableViewCell.self)) as! WhomiTableViewCell
        cell.dataWhomi = whomiViewModel.cellForRow(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        whomiViewModel.didSelect(at: indexPath)
    }
    
}
