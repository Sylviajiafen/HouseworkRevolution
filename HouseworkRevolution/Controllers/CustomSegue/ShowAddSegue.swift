//
//  ShowAddSegue.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

// swiftlint:disable multiple_closures_with_trailing_closure

class ShowAddSegue: UIStoryboardSegue {
    
    override func perform() {
        
        guard let source = self.source.view,
        
              let destination = self.destination.view
            
        else { return }
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        let screenHeight = UIScreen.main.bounds.size.height
        
        destination.frame = CGRect(x: 0, y: screenWidth, width: screenWidth, height: screenHeight)
        
        let window = UIApplication.shared.keyWindow
        
        window?.insertSubview(destination, aboveSubview: source)
        
        UIView.animate(withDuration: 0.4, animations: {
            
            source.frame = CGRect(x: -screenWidth, y: 0, width: screenWidth, height: screenHeight)
            
            destination.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            
        }) { (finished) in
            
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }

}
