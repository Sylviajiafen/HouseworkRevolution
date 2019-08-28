//
//  AuthViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/28.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var signUpView: UIView!
    
    @IBOutlet weak var signInView: UIView!
    
    @IBOutlet weak var userSettingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInView.isHidden = true
        
        userSettingView.isHidden = true
    }
    
    @IBAction func showSignIn(_ sender: Any) {
        
        signInView.isHidden = false
    }
    
    @IBAction func showSignUp(_ sender: Any) {
        
        signInView.isHidden = true
    }
    
}
