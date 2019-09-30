//
//  UserHelpViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class UserHelpViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var versionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestureToBackground()
        
        versionView.layer.roundCorners(radius: 10.0)
        
        versionView.layer.addShadow()
    }
    
    @IBAction func dismissUserHelp(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
    
    func addGestureToBackground() {
        
        let touchToDismiss = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapToDismiss))
        
        backgroundView.addGestureRecognizer(touchToDismiss)
    }
    
}

extension UIApplication {
    
    static var appVersion: String? {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

