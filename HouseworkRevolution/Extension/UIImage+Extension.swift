//
//  UIImage+Extension.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    case back
    case dismiss
    case information
    case lightGreenCircle
    
    case listUnselected
    case listSelected
    case missionUnselected
    case missionSelected
    case wishUnselected
    case wishSelected
    case familyUnselected
    case familySelected
    
    case deleteWish
    
    case cleanFloorICON
    case cleanToiletICON
    case cookICON
    case garbageICON
    case groceryICON
    case laundryICON
    case mopICON
    case vacuumICON
    case customWorkICON
    
    case valueHeart
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
