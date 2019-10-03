//
//  UIViewController+Extension.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/16.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertOf(title: String? = nil,
                     message: String,
                     dismissByCondition: Bool = false,
                     handler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var action = UIAlertAction()
        
        if dismissByCondition {
            
            action = UIAlertAction(title: "OK", style: .default, handler: { _ in
                
                handler?()
            })
            
        } else {
            
           action = UIAlertAction(title: "OK", style: .cancel)
        }
        
        action.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    func addTapToDismissGesture(on background: UIView) {
        
        let touchToDismiss = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapToDismiss))
        
        background.addGestureRecognizer(touchToDismiss)
    }

    @objc func tapToDismiss() {
        
        dismiss(animated: false, completion: nil)
    }
}
