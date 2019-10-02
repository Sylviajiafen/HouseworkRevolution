//
//  QRCodeViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/10/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var userCallLabel: UILabel!
    
    @IBOutlet weak var qrcodeView: UIImageView!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        userIDLabel.text = StorageManager.userInfo.userID
        
        userCallLabel.text = userName
        
        qrCodeImage.image = generateQRCode(from: StorageManager.userInfo.userID)
        
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
    
    func addGesture() {
        
        
    }
    
    @IBAction func backToFamilyPage(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
}

private struct QRCodeString {
    
    static let qrfilterName: String = "CIQRCodeGenerator"
    
    static let qrfilterValue: String = "inputMessage"
}
