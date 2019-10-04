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
            
        rotation.duration = 0.0045
            
        rotation.repeatCount = 70
            
        self.layer.add(rotation, forKey: nil)
        
    }
}

extension CALayer {
    
    func roundCorners(radius: CGFloat) {
        
        self.cornerRadius = radius
        
        if shadowOpacity != 0 {
            
            addShadowWithRoundedCorners()
        }
    }
    
    func addShadow() {
        
        self.shadowOffset = .zero
        
        self.shadowOpacity = 1.0
        
        self.shadowRadius = 10
        
        self.shadowColor = UIColor.white.cgColor
        
        self.masksToBounds = false
        
        if cornerRadius != 0 {
            
            addShadowWithRoundedCorners()
        }
    }
    
    private func addShadowWithRoundedCorners() {
        
        if let contents = self.contents {
            
            masksToBounds = false
            
            sublayers?.filter { $0.frame.equalTo(self.bounds) }
                .forEach { $0.roundCorners(radius: self.cornerRadius) }
            
            self.contents = nil
            
            if let sublayer = sublayers?.first {
                
                sublayer.removeFromSuperlayer()
            }
            
            let contentLayer = CALayer()
            
            contentLayer.contents = contents
            
            contentLayer.frame = bounds
            
            contentLayer.cornerRadius = cornerRadius
            
            contentLayer.masksToBounds = true
            
            insertSublayer(contentLayer, at: 0)
        }
    }
}
