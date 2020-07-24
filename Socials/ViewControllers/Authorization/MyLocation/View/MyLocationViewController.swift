//
//  MyLocationViewController.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import MapKit
import Lottie
import RxSwift
import RxCocoa
import SwiftOverlays

class MyLocationViewController: BaseAuthViewController {
    
    @IBOutlet weak var turnOnBtn: DesignableUIButton!
    @IBOutlet weak var searchLoc: DesignableUIButton!
    @IBOutlet weak var nextBtn: DesignableUIButton!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var viewDots: UIView!
    
    //PRIVATE
    private let locationManager = CLLocationManager()
    private var myLocation: (String, String)?
    
    private let myLocationViewModel = MyLocationViewModel()
    private let disposeBag = DisposeBag()
    
    fileprivate let animationView = AnimationView(name: "DotsAnimation")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTitle.attributedText = myLocationViewModel.titleNeedTurnOnGeoLoc()
        locationTitle.adjustsFontSizeToFitWidth = true
        locationTitle.minimumScaleFactor = 0.4
        locationTitle.lineBreakMode = .byTruncatingTail
        
        setupAnimationDots()
        subscribe()
    }
    
    private func subscribe(){
        myLocationViewModel.formatted_address.skip(1).asObservable().subscribe(onNext: { [weak self] (value) in
            self?.locationTitle.attributedText = self?.myLocationViewModel.titleSearchAddress()
           
            self?.locationTitle.adjustsFontSizeToFitWidth = true
            self?.locationTitle.minimumScaleFactor = 0.4
            self?.locationTitle.lineBreakMode = .byTruncatingTail

        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK:- Setup
    fileprivate func setupAnimationDots(){
        self.viewDots.addSubview(animationView)
        self.animationView.backgroundBehavior = .pauseAndRestore
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .clear
        
        self.viewDots.addConstraint(NSLayoutConstraint(item: animationView, attribute: .leading, relatedBy: .equal, toItem: self.viewDots, attribute: .leading, multiplier: 1.0, constant: 1))
        self.viewDots.addConstraint(NSLayoutConstraint(item: animationView, attribute: .trailing, relatedBy: .equal, toItem: self.viewDots, attribute: .trailing, multiplier: 1.0, constant: 1))
        self.viewDots.addConstraint(NSLayoutConstraint(item: animationView, attribute: .top, relatedBy: .equal, toItem: self.viewDots, attribute:.top, multiplier: 1.0, constant: 1))
        self.viewDots.addConstraint(NSLayoutConstraint(item: animationView, attribute: .bottom, relatedBy: .equal, toItem: self.viewDots, attribute: .bottom, multiplier: 1.0, constant: 1))
        viewDots.isHidden = true
    }
     

    //MARK:- Helpers
    private func geolocationIsOn(){
        turnOnBtn.isHidden = true
//        searchLoc.isHidden = true
        nextBtn.isHidden = false
    }
    
    private func geolocationIsOFF(){
        turnOnBtn.isHidden = false
//        searchLoc.isHidden = false
        nextBtn.isHidden = true
    }
    
    private func isNextEnable(){
        if let location = myLocationViewModel.location,
            location.lng != nil, location.lat != nil,
            myLocationViewModel.formatted_address.value != nil{
            nextBtn.isUserInteractionEnabled = true
            nextBtn.alpha = 1.0
             self.geolocationIsOn()
        }else{
            nextBtn.isUserInteractionEnabled = false
            nextBtn.alpha = 0.6
            self.geolocationIsOFF()
        }
    }
    
    private func titleNotFound(){
        self.locationTitle.attributedText = self.myLocationViewModel.titleLocationNotFound()
        self.locationTitle.adjustsFontSizeToFitWidth = true
        self.locationTitle.minimumScaleFactor = 0.4
        self.locationTitle.lineBreakMode = .byTruncatingTail
    }
    
    
    //MARK:- Request
    private func getLocationAddres(by location: CLLocationCoordinate2D){
        locationTitle.attributedText = nil
        viewDots.isHidden = false
        animationView.play()
        
        myLocationViewModel.requestLocations(by: location) { [weak self] (resultResponce) in
            self?.viewDots.isHidden = true
            switch resultResponce{
            case .success:
                self?.isNextEnable()
            case .fail:
                self?.titleNotFound()
            }
        }
    }
    
    private func getLocationAddres(by place_id: String?){
        guard let place_id = place_id else {
            self.titleNotFound()
            return
        }
        
        locationTitle.attributedText = nil
        viewDots.isHidden = false
        animationView.play()
        
        myLocationViewModel.requestPlaceDetail(by: place_id) { [weak self] (resultResponce, placeDetailsModel) in
            self?.viewDots.isHidden = true
            switch resultResponce{
            case .success:
                self?.isNextEnable()
            case .fail:
                self?.titleNotFound()
            }
        }
    }
    
    private func requestRegisterLocation(){
        SwiftOverlays.showBlockingWaitOverlay()
        myLocationViewModel.requestRegisterLocation { [weak self] (resultResponce, error) in
            SwiftOverlays.removeAllBlockingOverlays()
            switch resultResponce{
            case .success:
                self?.nextViewController()
            case .fail:
                self?.alert(at: error?.error ?? "", message: error?.message ?? "")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: SearchLocationViewController.self){
            if let dvc = segue.destination as? SearchLocationViewController{
                dvc.isConfirmData = {
                    [weak self] (address) in
                    self?.getLocationAddres(by: address.place_id)
                }
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: DesignableUIButton) {
        requestRegisterLocation()
    }
    
    @IBAction func searchLocation(_ sender: Any) {
        self.performSegue(withIdentifier: String(describing: SearchLocationViewController.self), sender: nil)
    }
    
    @IBAction func turnOn(_ sender: Any) {
        checkUsersLocationServicesAuthorization()
    }
    
    //MARK:- deinit
    deinit{
        print("MyLocationViewController is deinit")
    }
}

extension MyLocationViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        myLocation = ("\(Double(locValue.latitude))", "\(Double(locValue.longitude))")
        locationManager.stopUpdatingLocation()
        getLocationAddres(by: locValue)
    }
    
    
    func checkUsersLocationServicesAuthorization(){
        /// Check if user has authorized Total Plus to use Location Services
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                // This is the first and the ONLY time you will be able to ask the user for permission
                self.locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                geolocationIsOFF()
                break
                
            case .restricted, .denied:
                // Disable location features
                let alert = UIAlertController(title: NSLocalizedString("Allow Location Access", comment: "Alert"), message: NSLocalizedString("You need turn on location on this device to use our app", comment: "You need turn on location on this device to use our app"), preferredStyle: UIAlertController.Style.alert)
                
                // Button to Open Settings
                alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert Button"), style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                geolocationIsOFF()
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                // Enable features that require location services here.
                print("Full Access")
                geolocationIsOn()
                isNextEnable()
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
                break
            @unknown default:
                geolocationIsOFF()
                print("unknown")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .authorizedWhenInUse, .authorizedAlways:
            geolocationIsOn()
            isNextEnable()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            break
        default:
            geolocationIsOFF()
            print("unknown")
        }
    }
}
