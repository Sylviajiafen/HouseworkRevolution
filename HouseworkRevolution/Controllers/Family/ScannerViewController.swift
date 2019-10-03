//
//  ScannerViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/10/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

import AVFoundation

typealias QRCodeStringMessage = (QRCodeScannedResult<String>) -> Void

class ScannerViewController: UIViewController {

    @IBOutlet weak var dismissBtn: UIButton!
    
    @IBOutlet weak var noticeTitle: UILabel!
    
    @IBOutlet weak var pickFromGalleryBtn: UIButton!
    
    @IBOutlet weak var dierctToSettingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video) { [weak self] (agree) in
                
                if agree {
                    
                    self?.setUpCamera()
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        self?.noticeTitle.isHidden = true
                                   
                        self?.pickFromGalleryBtn.isHidden = true
                    }
                }
            }
            
        case .authorized:
            
            setUpCamera()
            
        case .denied, .restricted:
            
            noticeTitle.isHidden = true
                       
            pickFromGalleryBtn.isHidden = true
            
        @unknown default:
            
            fatalError()
        }
        
        setQRCodeFrame()
        
        setUpNotice()
        
        FirebaseUserHelper.shared.getAllUser { [weak self] (allUsers) in
            
            for user in allUsers {
                
                self?.allUserID.append(user.id)
            }
        }
    }
    
    var allUserID = [String]()
    
    weak var delegate: ScannerViewControllerDelegate?
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var qrCodeFrameView: UIView?
    
    let imagePicker = UIImagePickerController()

    func setQRCodeFrame() {
        
        qrCodeFrameView = UIView()
            
        if let qrCodeFrameView = qrCodeFrameView,
            let frameColor = UIColor.projectTitleLight {
                
            qrCodeFrameView.layer.borderColor = frameColor.cgColor
                
            qrCodeFrameView.layer.borderWidth = 2
                
            view.addSubview(qrCodeFrameView)
                
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    func setUpNotice() {
        
        if UserDefaults.standard.value(forKey: "userKey") == nil {
            
            noticeTitle.text = "掃描自己的 QRCode，系統將會自動輸入您的 ID"
            
        } else {
            
            noticeTitle.text = "掃描家人的 QRCode，找到家人的 ID 吧！"
        }
    }
    
//    func showUserNotFound() {
//
//        if UserDefaults.standard.value(forKey: "userKey") == nil {
//
//            showAlertOf(message: "沒有找到您")
//
//        } else {
//
//            showAlertOf(message: "找不到家人耶")
//        }
//    }
    
    func detectUser(by detectedString: String, completionHandler: @escaping QRCodeStringMessage) {
        
        if allUserID.contains(detectedString) {
            
            completionHandler(.userFound(detectedString))
            
        } else {
            
            if UserDefaults.standard.value(forKey: "userKey") == nil {
                
                completionHandler(.userNotFound("沒有找到您"))
                
            } else {
                
                completionHandler(.userNotFound("找不到家人耶"))
            }
        }
    }
    
    @IBAction func directToSetting(_ sender: Any) {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    @IBAction func pickFromGallery(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func backToSearchView(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func setUpCamera() {
        
        let deviceDiscoverySession =
            AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera],
                                             mediaType: AVMediaType.video,
                                             position: .back)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        
        guard let captureDevice = deviceDiscoverySession.devices.first else { return }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(input)
            
            captureSession.addOutput(captureMetadataOutput)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            videoPreviewLayer?.frame = view.layer.bounds
            
            view.layer.addSublayer(videoPreviewLayer!)
            
            view.bringSubviewToFront(dismissBtn)
            
            view.bringSubviewToFront(noticeTitle)
            
            view.bringSubviewToFront(pickFromGalleryBtn)
            
            captureSession.startRunning()
            
        } catch {
            
            noticeTitle.isHidden = true
            
            pickFromGalleryBtn.isHidden = true
   
            return
        }
        
        captureMetadataOutput.setMetadataObjectsDelegate(self,
                                                         queue: DispatchQueue.main)
        
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            
            qrCodeFrameView?.frame = CGRect.zero
            
        } else {
            
            guard let metadataObj = metadataObjects[0]
                as? AVMetadataMachineReadableCodeObject else { return }

            if metadataObj.type == AVMetadataObject.ObjectType.qr {

                let barCodeObject = videoPreviewLayer?
                    .transformedMetadataObject(for: metadataObj)
                
                qrCodeFrameView?.frame = barCodeObject!.bounds
                
                guard let detectedUid = metadataObj.stringValue else { return }
                
                detectUser(by: detectedUid) { [weak self] (result) in
                    
                    switch result {
                        
                    case .userFound(let uid):
                        
                        self?.delegate?.inputDetectedUser(id: uid)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        
                            self?.dismiss(animated: false, completion: nil)
                        }
                        
                    case .userNotFound(let message):
                        
                        self?.showAlertOf(message: message)
                }
                
            }
        }
        }
    }
    
}

extension ScannerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo
                                info: [UIImagePickerController.InfoKey: Any]) {
        
        print("進 didFinish")
        
        if let qrCodeImage = info[.originalImage] as? UIImage {
            
            guard let detector: CIDetector =
                CIDetector(ofType: CIDetectorTypeQRCode,
                           context: nil,
                           options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
                let ciImage: CIImage = CIImage(image: qrCodeImage)  else { return }
            
            var qrCodeString = ""
            
            if let features = detector.features(in: ciImage) as? [CIQRCodeFeature] {
                
                for feature in features {
                    
                    guard let message = feature.messageString else { return }
                    
                    qrCodeString += message
                }
                
                detectUser(by: qrCodeString) { [weak self] (result) in
                    
                    switch result {
                        
                    case .userFound(let uid):
                        
                        self?.delegate?.inputDetectedUser(id: uid)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        
                            self?.dismiss(animated: false, completion: nil)
                        }
                        
                        self?.imagePicker.dismiss(animated: false, completion: nil)
                        
                    case .userNotFound(let message):
                        
                        self?.imagePicker.dismiss(animated: true, completion: {
                            
                            self?.showAlertOf(message: message)
                        })
                        
                    }
                }
            }
            
        } else {
    
            print("Cannot convert QRCode into UIImage")
        }
    }
}

protocol ScannerViewControllerDelegate: AnyObject {
    
    func inputDetectedUser(id: String)
}
