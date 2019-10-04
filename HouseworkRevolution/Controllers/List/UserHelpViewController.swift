//
//  UserHelpViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import MessageUI

class UserHelpViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var versionView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapToDismissGesture(on: backgroundView)

        versionView.layer.roundCorners(radius: 10.0)
        
        versionView.layer.addShadow()
        
        versionLabel.text = UIApplication.appVersion
    }
    
    @IBAction func dismissUserHelp(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
  
    @IBAction func sendEmail(_ sender: Any) {
       
        let mail = MFMailComposeViewController()
        
        mail.mailComposeDelegate = self
        
        mail.setToRecipients(["eggie152832@gmail.com"])
        
        if let version = UIApplication.appVersion {
            
            mail.setSubject("我在「翻轉家事(\(version))」遇到了問題：")
            
        } else {
            
            mail.setSubject("我在「翻轉家事」遇到了問題：")
        }
        
        if MFMailComposeViewController.canSendMail() {

            present(mail, animated: true)
            
        } else {
            
            showAlertOf(message: "尚未設定手機的郵件帳戶，無法使用此功能")
        }
    }
    
}

extension UserHelpViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        
        if let error = error {
            
            print("MAIL ERR: \(error)")
            
        } else {
            
            switch result {
                
            case .sent:
                
                dismiss(animated: true, completion: nil)
                
                ProgressHUD.showＷith(text: "成功傳送！", self.view)
                
            default:
                
                dismiss(animated: true, completion: nil)
            }
            
        }
    }
}

extension UIApplication {
    
    static var appVersion: String? {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
