//
//  AuthorizationViewController.swift
//  Eschty
//
//  Created by Aisana on 23.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftOverlays

class AuthorizationViewController: BaseAuthViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var paginator: UIPageControl!
    @IBOutlet weak var privacyBtn: UIButton!
    
    //PRIVATE
    private let authorizationViewModel = AuthorizationViewModel()
    private var lastXPosition: CGFloat = 0.0
    
    private(set) lazy var facebookAuth = FacebookAuthService()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setPrivaceText()
        setupPaginator()
        
        subsribes()
    }
    
    private func subsribes(){
        facebookAuth.facebookAuthToken.subscribe(onNext: { [weak self] (facebookAuthToken) in
            if facebookAuthToken.accessToken?.userID != nil{
                let birthdayInFormated = self?.authorizationViewModel.setValidDate(strDate: facebookAuthToken.birthday)
                facebookAuthToken.birthday = birthdayInFormated
                self?.requestAuthFromFacebook(facebookAuthToken: facebookAuthToken)
            }else{
                SwiftOverlays.removeAllBlockingOverlays()
                self?.facebookAuth.logout()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideNavigationBar()
    }
    
    //MARK:- Helpers
    private func setPrivaceText(){
        let text = NSLocalizedString("By signing up you agree to our Terms & Privacy policy", comment: "text Terms & Privacy policy")
        let textUnderlined = NSLocalizedString("Terms & Privacy policy", comment: "Должен иметь слова которые нужно подчеркнуть в строке By signing up you agree to our Terms & Privacy policy")
       
        let rangeFullText = NSString(string: text).range(of: text, options: String.CompareOptions.caseInsensitive)
        let rangeUnderlined = NSString(string: text).range(of: textUnderlined, options: String.CompareOptions.caseInsensitive)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Medium", size: 13)!, NSAttributedString.Key.paragraphStyle : paragraphStyle], range: rangeFullText)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProDisplay-Medium", size: 13)!,
                                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue as Any], range: rangeUnderlined)
        privacyBtn.setAttributedTitle(attributedString, for: .normal)
    }
    
    private func setupPaginator(){
        paginator.numberOfPages = authorizationViewModel.nubmerOfRow()
        paginator.currentPage = 0
    }
    
    //MARK:- Request
    private func requestAuthFromFacebook(facebookAuthToken: FacebookAuthToken){
        authorizationViewModel.requestAauthProviderUser(facebookAuthToken: facebookAuthToken) {
            [weak self] (resultResponce, oAuthReg, error) in
            
            SwiftOverlays.removeAllBlockingOverlays()
            
            switch resultResponce{
            case .success:
                if oAuthReg?.regToken != nil{
                    self?.performSegue(withIdentifier: String(describing: LoginViewController.self), sender: oAuthReg?.regToken)
                }else{
                    self?.nextViewController()
                }
            case .fail:
                break
            }
        }
    }
    
    //MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: LoginViewController.self){
            if let dvc = segue.destination as? LoginViewController{
                dvc.loginViewModel = LoginViewModel(regToken: sender as? String)
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func loginFB(_ sender: UIButton) {
        SwiftOverlays.showBlockingWaitOverlay()
        facebookAuth.login(vc: self)
    }
    
    @IBAction func loginEmailOrPhone(_ sender: Any) {
        self.performSegue(withIdentifier: String(describing: LoginViewController.self), sender: nil)
    }
    
    
    //MARK:- deinit
    deinit {
        print("AuthorizationViewController is deinit")
    }
}

//MARK:- Collection View Slider
extension AuthorizationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return authorizationViewModel.nubmerOfRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AuthorizationCollectionViewCell.self), for: indexPath) as! AuthorizationCollectionViewCell
        cell.dataAuth = authorizationViewModel.cellFor(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.height
        let w = collectionView.frame.width
        return CGSize(width: w, height: h)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else{
            return
        }
        
        if scrollView.contentOffset.x != lastXPosition{
            lastXPosition = scrollView.contentOffset.x
        }
        let pageIndex = round(lastXPosition/self.collectionView.bounds.width)
        paginator.currentPage = Int(pageIndex)
    }
}
