//
//  CheckMissionViewModel.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/12/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import UIKit

class MissionCellViewModel {
    
    let housework: Mission
    
    init(housework: Mission) {
        
        self.housework = housework
    }
    
    var title: String {
        
        return housework.title
    }
    
    var tiredValue: Int {
        
        return housework.tiredValue
    }
    
    var icon: UIImage? {
        
        switch title {
            
        case DefaultHouseworks.sweep.rawValue:
            
            return UIImage.asset(.cleanFloorICON)
            
        case DefaultHouseworks.mop.rawValue:
            
            return UIImage.asset(.mopICON)
            
        case DefaultHouseworks.vacuum.rawValue:
            
            return UIImage.asset(.vacuumICON)
            
        case DefaultHouseworks.garbage.rawValue:
            
            return UIImage.asset(.garbageICON)
        
        case DefaultHouseworks.laundry.rawValue:
            
            return UIImage.asset(.laundryICON)
            
        case DefaultHouseworks.cook.rawValue:
            
            return UIImage.asset(.cookICON)
            
        case DefaultHouseworks.grocery.rawValue:
            
            return UIImage.asset(.groceryICON)
            
        case DefaultHouseworks.toilet.rawValue:
            
            return UIImage.asset(.cleanToiletICON)
            
        default:
           
           return UIImage.asset(.customWorkICON)
        }
    }
}

extension MissionCellViewModel {
    
    func configure(_ cell: MissionListTableViewCell) {
        
        cell.missionLabel.text = title
        
        cell.tiredValueLabel.text = String(tiredValue)
        
        cell.houseworkIcon.image = icon
    }
}
