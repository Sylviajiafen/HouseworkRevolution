//
//  NSRegularExpression+Extension.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/24.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation

extension NSRegularExpression {
    
    convenience init(_ pattern: String) {
        
        do {
            
            try self.init(pattern: pattern)
            
        } catch {
            
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool {
        
        let range = NSRange(location: 0, length: string.utf16.count)
        
        let char = string.cString(using: .utf8)

        let isBackSpace = strcmp(char, "\\b")

        if isBackSpace == -92 {

            return true

        } else {
        
            return firstMatch(in: string, options: [], range: range) != nil
        }
    }
}
