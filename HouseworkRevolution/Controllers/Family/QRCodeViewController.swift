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
    
    @IBOutlet weak var qrcodeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIDLabel.text = StorageManager.userInfo.userID
    }
    
    @IBAction func backToFamilyPage(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
    
}
