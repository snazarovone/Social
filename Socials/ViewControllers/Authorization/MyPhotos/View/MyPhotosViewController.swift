//
//  MyPhotosViewController.swift
//  Jivys
//
//  Created by Aisana on 26.05.2020.
//  Copyright © 2020 Aisana. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa
import SwiftOverlays

class MyPhotosViewController: BaseAuthViewController {
    
    @IBOutlet var photos: [DesignableUIImageView]!
    @IBOutlet var removeBtns: [UIButton]!
    @IBOutlet weak var nextBtn: DesignableUIButton!
    
    //PRIVATE
    private let imagePicker = UIImagePickerController()
    private let cameraPicker = UIImagePickerController()
    private var context = 0
    
    private let myPhotoViewModel = MyPhotosViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribes()
    }
    

    private func subscribes(){
        myPhotoViewModel.photos.subscribe(onNext: { [weak self] (images) in
            for (i, img) in images.enumerated(){
                if img == nil{
                    self?.photos[i].image = #imageLiteral(resourceName: "1st image.png")
                    self?.removeBtns[i].isHidden = true
                }else{
                    self?.photos[i].image = img
                    self?.removeBtns[i].isHidden = false
                }
            }
            self?.validationField()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK:- Helpers
    private func requestSendPhoto(){
        let data = myPhotoViewModel.getPhotoForSend()
        SwiftOverlays.showBlockingWaitOverlay()
        myPhotoViewModel.sendPhotos(data: data) { [weak self] (result, error) in
            switch result{
            case .success:
                self?.requestSendKeys()
            case .fail:
                SwiftOverlays.removeAllBlockingOverlays()
                self?.alert(at: error?.error ?? "", message: error?.message ?? "")
            }
        }
    }
    
    private func requestSendKeys(){
        let keys = myPhotoViewModel.getKeysForSend()
        self.myPhotoViewModel.sendPhotoKey(keys: keys) { [weak self] (resultResponce, error) in
            SwiftOverlays.removeAllBlockingOverlays()
            switch resultResponce{
            case .success:
                self?.nextViewController()
            case .fail:
                self?.alert(at: error?.error, message: error?.message ?? "")
            }
        }
    }
    
    //MARK:- Helpers
    private func alertSheetCameraOrLib(){
//        let title = NSLocalizedString("Select", comment: "Title alert sheet select camera or library")
//        let message = NSLocalizedString("How to add a photo?", comment: "Title alert sheet select camera or library")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionCameraTitle = NSLocalizedString("Camera", comment: "Button Camera")
        let actionPhotoTitle = NSLocalizedString("Photo", comment: "Button Photo")
        let cancelTitle = NSLocalizedString("Cancel", comment: "Title Alert Action Cancel")
        
        let actionCamera = UIAlertAction(title: actionCameraTitle, style: .default) { [weak self] (_) in
            self?.openCamera()
        }
        
        let actionPhoto = UIAlertAction(title: actionPhotoTitle, style: .default) { [weak self] (_) in
            self?.setupPockerVC()
        }
        
        let actionCancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func validationField(){
        if myPhotoViewModel.isExistPhoto(){
            nextBtn.alpha = 1.0
            nextBtn.isEnabled = true
        }else{
            nextBtn.alpha = 0.6
            nextBtn.isEnabled = false
        }
    }
    
    //MARK:- Actions
    @IBAction func addPhoto(_ sender: UIButton) {
        myPhotoViewModel.currentPhoto = sender.tag
        alertSheetCameraOrLib()
    }
    
    @IBAction func removePhoto(_ sender: UIButton) {
        performSegue(withIdentifier: String(describing: AlertDeletePhotoViewController.self), sender: sender.tag)
    }
    
    @IBAction func next(_ sender: UIButton) {
        requestSendPhoto()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: AlertDeletePhotoViewController.self){
            if let dvc = segue.destination as? AlertDeletePhotoViewController, let index = sender as? Int{
                dvc.isRemove = {
                    [weak self] in
                    self?.myPhotoViewModel.currentPhoto = index
                    self?.myPhotoViewModel.addPhoto(image: nil)
                    self?.myPhotoViewModel.addUrlPhoto(url: nil)
                    self?.validationField()
                }
            }
        }
    }
    
    //MARK:- deinit
    deinit {
        print("MyPhotosViewController is deinit")
    }
    
}

//MARK:- Image Picker
extension MyPhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private func setupPockerVC(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.delegate = self
        checkPermission()
    }
    
    private func openCamera(){
        cameraPicker.delegate = self
        cameraPicker.allowsEditing = true
        cameraPicker.sourceType = .camera
        cameraPicker.cameraCaptureMode = .photo
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCaptureSessionDidStartRunning(notification:)), name: NSNotification.Name.AVCaptureSessionDidStartRunning, object: nil)
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleCaptureSessionDidStopRunning(notification:)), name: NSNotification.Name.AVCaptureSessionDidStartRunning, object: nil)
        //
        
        present(cameraPicker, animated: true)
    }
    
    @objc func handleCaptureSessionDidStartRunning(notification: NSNotification){
        guard let session = notification.object as? AVCaptureSession else { return }
        session.addObserver(self, forKeyPath: "inputs", options: [ .old, .new ], context: &context)
    }
    
    
    @objc func handleCaptureSessionDidStopRunning(notification: NSNotification){
        guard let session = notification.object as? AVCaptureSession else { return }
        session.removeObserver(self, forKeyPath: "inputs")
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &self.context {
            if let inputs = change?[NSKeyValueChangeKey.newKey] as? [AnyObject], let captureDevice = (inputs.first as? AVCaptureDeviceInput)?.device {
                switch captureDevice.position {
                case .back:
                    DispatchQueue.main.async {
                        self.cameraPicker.cameraViewTransform = self.cameraPicker.cameraViewTransform.scaledBy(x: -1, y: 1)
                    }
                    print("Switched to back camera")
                case .front:
                    DispatchQueue.main.async {
                        self.cameraPicker.cameraViewTransform = self.cameraPicker.cameraViewTransform.scaledBy(x: -1, y: 1)
                    }
                    print("Switched to front camera")
                case .unspecified:
                    break
                @unknown default:
                    break
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
           
            let pHAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
            myPhotoViewModel.addUrlPhoto(url: pHAsset?.value(forKey: "filename") as? String)
            
            if myPhotoViewModel.equalsPhoto() == true{
                myPhotoViewModel.addUrlPhoto(url: nil)
                myPhotoViewModel.addPhoto(image: nil)
                DispatchQueue.main.async {
                    self.alert(at: nil, message: NSLocalizedString("Please, upload another photo", comment: "Please, upload another photo"))
                }
            }else{
                myPhotoViewModel.addPhoto(image: pickedImage)
                validationField()
            }
        }
        dismiss(animated: true) {
        }
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            DispatchQueue.main.async {
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    DispatchQueue.main.async {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            DispatchQueue.main.async {
                self.openPermission()
            }
            
        @unknown default:
            print("unknow ndefault")
        }
    }
    
    private func openPermission(){
        let warning = NSLocalizedString("Warning", comment: "Alert title")
        let message = NSLocalizedString("User denied access to photo library, allow?", comment: "Alert message photo lib")
        let actionYesTitle = NSLocalizedString("Yes", comment: "Alert action yes")
        let actionNoTitle = NSLocalizedString("No", comment: "Alert action no")
        
        let alert = UIAlertController(title: warning, message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: actionYesTitle, style: .default) { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        
        let actionNo = UIAlertAction(title: actionNoTitle, style: .cancel, handler: nil)
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        self.present(alert, animated: true, completion: nil)
    }
}
