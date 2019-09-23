//
//  UIView + Extension.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/28.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

extension UIView {
    
    func rotate() {
            
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        rotation.fromValue = -Double.pi / 8
        
        rotation.toValue = Double.pi / 8
            
        rotation.duration = 0.005
            
        rotation.repeatCount = 60
            
        self.layer.add(rotation, forKey: nil)
        
    }
    
}
