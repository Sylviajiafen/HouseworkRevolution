//
//  UIViewController+Extension.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/16.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertOf(message: String, dismiss: Bool = false, handler: (() ->Void)? = nil) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        var action = UIAlertAction()
        
        if dismiss {
            
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

   
}
