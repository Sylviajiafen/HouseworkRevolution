//
//  UIColor+ Extension.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

private enum ProjectColor: String {
    
    case buttonSelected
    
    case buttonUnSelected
    
    case noticeGray
    
    case projectBackground
    
    case projectTitle
    
    case projectTitleLight
    
    case superLightGray
    
    case lightGreen
    
    case lightLake
    
    case lightPink
    
    case titleBlue
    
    case titleLightBlue
    
    case contentBlue
    
    case darkSky
    
    case cellGreen
    
    case lightCellGreen
    
    case darkCellGreen
    
    case darkRed
}

extension UIColor {
    
    private static func ProjectColor(_ color: ProjectColor) -> UIColor? {
        
        return UIColor(named: color.rawValue)
    }
    
    static let buttonSelected = ProjectColor(.buttonSelected)

    static let buttonUnSelected = ProjectColor(.buttonUnSelected)

    static let noticeGray = ProjectColor(.noticeGray)

    static let projectBackground = ProjectColor(.projectBackground)

    static let projectTitle = ProjectColor(.projectTitle)

    static let projectTitleLight = ProjectColor(.projectTitleLight)

    static let superLightGray = ProjectColor(.superLightGray)
    
    static let cellGreen = ProjectColor(.cellGreen)
    
    static let lightCellGreen = ProjectColor(.lightCellGreen)
    
    static let lightGreen = ProjectColor(.lightGreen)
}
