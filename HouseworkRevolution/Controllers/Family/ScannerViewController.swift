//
//  ScannerViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/10/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

import AVFoundation

import Photos

typealias QRCodeStringMessage = (QRCodeScannedResult<String>) -> Void

class ScannerViewController: UIViewController {

    @IBOutlet weak var dismissBtn: UIButton!
    
    @IBOutlet weak var noticeTitle: UILabel!
    
    @IBOutlet weak var pickFromGalleryBtn: UIButton!
    
    @IBOutlet weak var dierctToSettingBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        setSubViews(shouldHide: true)
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
            case .notDetermined:
            
                AVCaptureDevice.requestAccess(for: .video) { [weak self] (agree) in
                
                if agree {
                    
                    self?.setUpCamera()
                    
                } else {
                    
                    self?.setSubViews(shouldHide: true)
                }
            }
            
            case .authorized:
            
                setUpCamera()
            
            case .denied, .restricted:
            
                setSubViews(shouldHide: true)
            
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
    
    var canGetCamraDevice: Bool = true

    func setQRCodeFrame() {
        
        qrCodeFrameView = UIView()
            
        if let qrCodeFrameView = qrCodeFrameView,
            let frameColor = UIColor.projectTitleLight {
                
            qrCodeFrameView.layer.borderColor = frameColor.cgColor
                
            qrCodeFrameView.layer.borderWidth = 2

            DispatchQueue.main.async { [weak self] in
                    
                self?.view.addSubview(qrCodeFrameView)
                    
                self?.view.bringSubviewToFront(qrCodeFrameView)
            }
        }
    }
    
    func setUpNotice() {
        
        if UserDefaults.standard.value(forKey: "userKey") == nil {
            
            noticeTitle.text = "掃描自己的 QRCode，系統將會自動輸入您的 ID"
            
        } else {
            
            noticeTitle.text = "掃描家人的 QRCode，找到家人的 ID 吧！"
        }
    }
    
    func setSubViews(shouldHide: Bool) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.noticeTitle.isHidden = shouldHide
            
            self?.pickFromGalleryBtn.isHidden = shouldHide
            
        }
    }
    
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
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            
                if status == .authorized {
                   
                    DispatchQueue.main.async {
                    
                        guard let strongSelf = self else { return }
                    
                        strongSelf.imagePicker.allowsEditing = false
                    
                        strongSelf.imagePicker.sourceType = .photoLibrary
                    
                        strongSelf.present(strongSelf.imagePicker, animated: true, completion: nil)
                    }
                }
            }
            
        } else if status == .authorized {
            
            DispatchQueue.main.async { [weak self] in
            
                guard let strongSelf = self else { return }
            
                strongSelf.imagePicker.allowsEditing = false
            
                strongSelf.imagePicker.sourceType = .photoLibrary
            
                strongSelf.present(strongSelf.imagePicker, animated: true, completion: nil)
            }
        
        } else {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.showAuthAlertAndDirectToSettings(message: "請先至設定開啟相簿權限")
            }
        }
        
    }
    
    @IBAction func backToSearchView(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func setUpCamera() {
        
//        if #available(iOS 13.0, *) {
//
//            let deviceDiscoverySession =
//                AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTripleCamera],
//                                                 mediaType: AVMediaType.video,
//                                                 position: .back)
//        } else {
//            // Fallback on earlier versions
//        }

        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            
            setSubViews(shouldHide: true)
            
            DispatchQueue.main.async { [weak self] in
                
                self?.showAlertOf(title: nil,
                                  message: "本機型無法取用相機裝置",
                                  dismissByCondition: true,
                                  handler: {
                     
                    self?.dismiss(animated: false, completion: nil)
                })
            }
                        
        return }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        
        setSubViews(shouldHide: false)
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(input)
            
            captureSession.addOutput(captureMetadataOutput)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            DispatchQueue.main.async { [weak self] in

                guard let strongSelf = self else { return }

                strongSelf.videoPreviewLayer?.frame = strongSelf.view.layer.bounds

                guard let videoPreview = strongSelf.videoPreviewLayer else { return }
                
                strongSelf.view.layer.addSublayer(videoPreview)

                strongSelf.view.bringSubviewToFront(strongSelf.dismissBtn)

                strongSelf.view.bringSubviewToFront(strongSelf.noticeTitle)

                strongSelf.view.bringSubviewToFront(strongSelf.pickFromGalleryBtn)

                strongSelf.captureSession.startRunning()
            }
            
        } catch {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.showAlertOf(title: nil,
                                  message: "無法取用相機裝置",
                                  dismissByCondition: true,
                                  handler: {
                     
                    self?.dismiss(animated: false, completion: nil)
                })
            }
   
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
