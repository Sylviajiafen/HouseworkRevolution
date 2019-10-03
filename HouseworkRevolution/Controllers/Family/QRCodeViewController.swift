//
//  QRCodeViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/10/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import Photos

class QRCodeViewController: UIViewController {

    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var userCallLabel: UILabel!
    
    @IBOutlet weak var qrcodeView: UIImageView!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    @IBOutlet weak var backgroundDarkView: UIView!
    
    @IBOutlet weak var QRCodeInfoView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        userIDLabel.text = StorageManager.userInfo.userID
        
        userCallLabel.text = userName
        
        qrCodeImage.image = generateQRCode(from: StorageManager.userInfo.userID)
        
        addTapToDismissGesture(on: backgroundDarkView)
    }
    
    var userName = ""
    
    func generateQRCode(from string: String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: QRCodeString.qrfilterName) {
            
            filter.setValue(data, forKey: QRCodeString.qrfilterValue)
            
            let transform = CGAffineTransform(scaleX: 8, y: 8)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    @IBAction func saveQRCodeToLibrary(_ sender: Any) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            
                if status == .authorized {
                   
                    DispatchQueue.main.async {
                        
                        self?.saveQRCodeInfoImage()
                    }
                } 
            }
            
        } else if status == .authorized {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.saveQRCodeInfoImage()
            }
        
        } else {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.showAuthAlertAndDirectToSettings(message: "請先至設定開啟相簿權限")
            }
        }
        
    }
    
    func saveQRCodeInfoImage() {
        
        let renderer = UIGraphicsImageRenderer(size: QRCodeInfoView.bounds.size)
        
        let image = renderer.image(actions: { [weak self] (context) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.QRCodeInfoView.drawHierarchy(in: strongSelf.QRCodeInfoView.bounds,
                                                    afterScreenUpdates: true)
        })
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSavingResult), nil)
    }
    
    @objc func imageSavingResult(_ image: UIImage,
                                 didFinishSavingWithError error: Error?,
                                 contextInfo: UnsafeRawPointer) {
        if let error = error {
           
            showAlertOf(message: "無法儲存至相簿")
            
            print(error.localizedDescription)
            
        } else {
            
            ProgressHUD.showＷith(text: "儲存至相簿", self.view)
        }
    }
    
    @IBAction func backToFamilyPage(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
}

private struct QRCodeString {
    
    static let qrfilterName: String = "CIQRCodeGenerator"
    
    static let qrfilterValue: String = "inputMessage"
}
