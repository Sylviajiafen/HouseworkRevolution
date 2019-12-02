//
//  CheckMissionViewModel.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/12/3.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import UIKit

class CheckMissionViewModel {
    
    let day: String

    var cellViewModel = [MissionCellViewModel]()
    
    func getMission(completion: @escaping () -> Void) {
        
        FirebaseManager.shared.getAllMissions(day: self.day) { [weak self] (dailyMissions) in
            
            for mission in dailyMissions {
                
                self?.cellViewModel.append(MissionCellViewModel(housework: mission))
            }
            
            completion()
        }
    }
    
    init(day: String) {
        
        self.day = day
    }
}
