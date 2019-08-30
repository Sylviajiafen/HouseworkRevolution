//
//  UserInputTextField.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class UserInputTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addUnderLine()
    }

    private func addUnderLine() {
        
        let underline = UIView()
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(underline)
        
        NSLayoutConstraint.activate([
            
            leadingAnchor.constraint(equalTo: underline.leadingAnchor),
            trailingAnchor.constraint(equalTo: underline.trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1.0),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5.0)
            ])
        
        underline.backgroundColor = UIColor(named: "superLightGray")
    }

}
