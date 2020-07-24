//
//  BinocularsViewController.swift
//  Jivys
//
//  Created by Aisana on 04.06.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftOverlays
import AnimatedCollectionViewLayout

class BinocularsViewController: BaseItemsViewController {
    
    @IBOutlet weak var selectItemView: DesignableUIViewEasy!
    @IBOutlet weak var leadingSelectedItem: NSLayoutConstraint!
    @IBOutlet weak var heightInd: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackItem: UIStackView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var pin: UIImageView! //for hide and show
    @IBOutlet weak var match: UILabel!
    @IBOutlet weak var matchIcon: UIImageView! //for hide and show
    @IBOutlet var actions: [DesignableUIButton]!
    @IBOutlet weak var filterBtn: DesignableUIButton!
    
    @IBOutlet var doubleGesture: UITapGestureRecognizer!
    @IBOutlet var oneTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var addGoalContainer: UIView!
    
    private var viewModel: BinocularsViewModel!
    private var lastXPosition: CGFloat = 0.0
    private var showUserInfo: Bool = false
    
    //Animate collection parallax
    private var direction: UICollectionView.ScrollDirection = .horizontal
    private let animator: LayoutAttributesAnimator = ParallaxAttributesAnimator(speed: 0.1)
    
    private var isShowAddGoal: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indentTop()
        self.leadingSelectedItem.constant = getPositionItemBinocle(item: .search)
        
        viewModel = BinocularsViewModel(sizeImage: CGSize(width: collectionView.frame.width, height: collectionView.frame.height))
        
        //приоритет у двойного клика
        oneTapGesture.require(toFail: doubleGesture)
        
        if let layout = collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = direction
            layout.animator = animator
        }
        
        subscribes()
        reqestResultsUser(isNew: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideNavigationBar()
    }
    
    private func subscribes(){
        viewModel.resultsUser.asObservable().subscribe(onNext: { [weak self] (value) in
            if let index = self?.viewModel.currentItem.value, index < value.count{
            }else{
                if value.count > 0{
                    self?.viewModel.currentItem.accept(0)
                    if self?.isShowAddGoal.value != false{
                        self?.isShowAddGoal.accept(false)
                    }
                }else{
                    if self?.isShowAddGoal.value != true{
                        self?.isShowAddGoal.accept(true)
                    }
                }
            }
            self?.collectionView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.currentItem.asObservable().subscribe(onNext: { [weak self] (value) in
            self?.initItemLines()
            self?.updateDataUser()
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                if self?.viewModel.numberOfItemsInSection() ?? 0 > 0{
                    self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        isShowAddGoal.asObservable().subscribe(onNext: { [weak self] (value) in
            guard let tb = self?.tabBarController?.tabBar,  let height = self?.view.frame.height, let heightwithOutSafeArea = (self?.tabBarController as? TabBarJivysViewController)?.heightwithOutSafeArea else {return}
    
            print(heightwithOutSafeArea)
            
            if heightwithOutSafeArea + 20.0 == height{
                DispatchQueue.main.async {
                    if value{
                        tb.frame = CGRect(x: 0, y: 48, width: tb.frame.size.width, height: tb.frame.size.height)
                    }else{
                        tb.frame = CGRect(x: 0, y: 32, width: tb.frame.size.width, height: tb.frame.size.height)
                    }
                }
            }
            
            if value{
                self?.colorsAddGoals()
            }else{
                self?.colorsSearch()
            }
            
             self?.addGoalContainer.isHidden = !value
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK:- Requests
    public func reqestResultsUser(isNew: Bool){
        SwiftOverlays.showBlockingWaitOverlay()
        
        if isNew{
            viewModel.initNumberPages()
        }
        
        RequsetResultsUser.requestResultsUsers(at: viewModel.page, size: viewModel.size) { [weak self] (result, data) in
            
            SwiftOverlays.removeAllBlockingOverlays()
            
            switch result{
            case .success:
                if isNew{
                    self?.viewModel.resultsUser.accept(data?.items ?? [])
                    self?.viewModel.total = data?.total ?? 0
                    self?.viewModel.getMaxPage()
                    if (data?.items ?? []).count != 0{
                        self?.showTips()
                    }
                }else{
                    if data?.total != self?.viewModel.total{
                        self?.reqestResultsUser(isNew: true)
                    }else{
                        self?.viewModel.addNewResultUsers(items: data?.items ?? [])
                    }
                }
            case .fail:
                if data?.status == 401{
                    //выход
                    self?.logout()
                }else{
                    if let message = data?.errorDetails{
                        self?.showAlert(title: data?.error, message: message, callBack: {})
                    }
                }
            }
        }
    }
    
    private func requestLike(at userID: String?, likeType: BottomAction){
        guard let userID = userID else {
            return
        }
        RequsetResultsUser.requestLike(at: userID, likeType: likeType)
    }
    
    
    //MARK:- Helpers
    private func indentTop(){
        if self.tabBarController?.tabBar.frame.height ?? 80.0 <= 49.0{
            heightInd.constant = heightInd.constant - 16
        }
    }
    
    private func initItemLines(){
        stackItem.removeAllArrangedSubviews()
        let count = viewModel.numberOfItemsInSection()
        for i in 0..<count{
            let view = DesignableUIViewEasy()
            view.borderRadius = 1.5
            view.backgroundColor = .white
            if i == viewModel.indexPhoto{
                view.alpha = 0.8
            }else{
                view.alpha = 0.14
            }
            stackItem.addArrangedSubview(view)
        }
    }
    
    private func updateItemLines(){
        for (i, item) in stackItem.arrangedSubviews.enumerated(){
            if i == viewModel.indexPhoto{
                item.alpha = 0.8
            }else{
                item.alpha = 0.14
            }
        }
    }
    
    private func updateDataUser(){
        name.text = viewModel.nameAndAge
        distance.text = viewModel.miles
        match.text = viewModel.ofMatch
    }
    
    private func scaleButton(at button: DesignableUIButton){
        UIView.animate(withDuration: 0.5,
        animations: {
            button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.5) {
                button.transform = CGAffineTransform.identity
            }
        })
    }
    
    private func action(at button: DesignableUIButton){
        var actBtn: BottomAction = .like
        
        for item in BottomAction.allCases{
            if item.tag == button.tag{
                actBtn = item
            }
        }
        
        scaleButton(at: button)
        
        if actBtn == .returnAction{
            viewModel.previousCurrentItem()
            return
        }
        
        requestLike(at: viewModel.userID, likeType: actBtn)
        
        if pin.alpha == 0.0{
            showHideInfoUser()
        }
        
        switch viewModel.nextCurentItem() {
        case .download:
            reqestResultsUser(isNew: false)
        case .end:
            if isShowAddGoal.value != true{
                self.isShowAddGoal.accept(true)
            }
        case .next:
            break;
        }
        
    }
    
    private func showHideInfoUser(){
        var alpha = pin.alpha
        if alpha == 1.0{
            alpha = 0.0
        }else{
            alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.4) {
            self.name.alpha = alpha
            self.pin.alpha = alpha
            self.distance.alpha = alpha
            self.match.alpha = alpha
            self.matchIcon.alpha = alpha
            self.filterBtn.alpha = alpha
         
            for item in self.actions{
                item.alpha = alpha
            }
        }
    }
    
    //MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: TipsViewController.self), let dvc = segue.destination as? TipsViewController{
            dvc.topValue = matchIcon.frame.origin.y
            dvc.matchValue = viewModel.ofMatch
            return
        }
        
        if segue.identifier == String(describing: AddGoalsViewController.self), let dvc = segue.destination as? AddGoalsViewController{
            dvc.selectedItemPosition = getPositionItemBinocle(item: .search)
            dvc.updateResultsUser = {
                [weak self] in
                self?.reqestResultsUser(isNew: true)
            }
            return
        }
        
    }
    
    //MARK:- Show Tips
    private func showTips(){
        if UserDefaults.standard.value(forKeyPath: UDID.isFirstStartApp.key) as? Bool ?? true{
            UserDefaults.standard.set(false, forKey: UDID.isFirstStartApp.key)
            self.performSegue(withIdentifier: String(describing: TipsViewController.self), sender: nil)
        }
    }
    
    //MARK:- Actions
    @IBAction func filters(_ sender: DesignableUIButton) {
    }
    
    @IBAction func bottomBtnAction(_ sender: DesignableUIButton) {
       action(at: sender)
    }
    
    @IBAction func upGesture(_ sender: UISwipeGestureRecognizer) {
        let actBtn: BottomAction = .like
        action(at: actions[actBtn.tag])
    }
    
    @IBAction func downGesture(_ sender: UISwipeGestureRecognizer) {
        let actBtn: BottomAction = .dislike
        action(at: actions[actBtn.tag])
    }
    
    @IBAction func doubleTap(_ sender: UITapGestureRecognizer) {
        let actBtn: BottomAction = .superLike
        action(at: actions[actBtn.tag])
    }
    
    @IBAction func oneTap(_ sender: UITapGestureRecognizer) {
        showHideInfoUser()
    }
    
    @IBAction func rightGesture(_ sender: UISwipeGestureRecognizer) {
        if viewModel.numberOfItemsInSection() == 1{
            self.performSegue(withIdentifier: String(describing: UserInfoViewController.self), sender: nil)
        }
    }
    
    //MARK:- deinit
    deinit{
        print("BinocularsViewController is deinit")
    }
    
}

//MARK:- CollectionView
extension BinocularsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BinocularsCollectionViewCell.self), for: indexPath) as! BinocularsCollectionViewCell
        cell.dataItem = viewModel.cellForRow(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.height)
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height+40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else{
            return
        }
        
        if scrollView.contentOffset.x != lastXPosition{
            lastXPosition = scrollView.contentOffset.x
        }
        
        
        let pageIndex = round(lastXPosition/self.collectionView.bounds.width)
        if Int(pageIndex) != viewModel.indexPhoto{
            viewModel.indexPhoto = Int(pageIndex)
            updateItemLines()
        }
        
        if lastXPosition < -20.0{
            self.showUserInfo = true
        }
        
        if self.showUserInfo == true && lastXPosition == 0.0{
            self.showUserInfo = false
            self.performSegue(withIdentifier: String(describing: UserInfoViewController.self), sender: nil)
        }
    }
}
