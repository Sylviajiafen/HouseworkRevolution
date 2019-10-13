//
//  UITextFiled+Extension.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/10/4.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

extension UITextField {
    
    func clearText() {
        
        self.text = ""
    }
}

extension UITextView {
    
    func clearText() {
        
        self.text = ""
    }
    
    func setUpBy(text: String = "", font: UIFont?, textColor: UIColor?) {
        
        if let color = textColor, let textFont = font {
        
            self.textColor = color
            
            self.font = textFont
            
        } else {
            
            self.textColor = .darkGray
        }
     
        self.text = text
    }
}
