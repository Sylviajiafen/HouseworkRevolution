//
//  String+ Extension.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/18.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

extension String {
    
    func isContainsPhoneticCharacters() -> Bool {
        
        for scalar in self.unicodeScalars {
            
            if (scalar.value >= 12549 && scalar.value <= 12582) ||
                (scalar.value == 12584 || scalar.value == 12585 || scalar.value == 19968) {
                return true
            }
        }
        return false
        
    }
    
}
