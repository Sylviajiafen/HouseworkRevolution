//
//  TextCountLimitBaseViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/10/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class TextCountLimitBaseViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var textLimitCount: Int { return 0 }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false}

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= textLimitCount
    }

}
