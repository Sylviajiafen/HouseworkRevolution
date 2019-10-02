//
//  ScannerViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/10/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

import AVFoundation

class ScannerViewController: UIViewController {

    @IBOutlet weak var dismissBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCamera()
        
        setQRCodeFrame()
        
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
            
            captureSession.startRunning()
            
        } catch {
            
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
                
                if allUserID.contains(detectedUid) {
                    
                    self.delegate?.inputDetectedUser(id: detectedUid)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        
                        self?.dismiss(animated: false, completion: nil)
                    }
                    
                } else {
                    
                    showAlertOf(message: "找不到家人耶")
                }
            }
        }
    }
    
}

protocol ScannerViewControllerDelegate: AnyObject {
    
    func inputDetectedUser(id: String)
}
