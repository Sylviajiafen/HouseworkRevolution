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
    
    var cellViewModels = [WeekdayInEng.Monday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Tuesday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Wednesday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Thursday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Friday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Saturday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Sunday.rawValue: [MissionCellViewModel]()]
    
    func getMissions(completion: @escaping () -> Void) {
        
        for weekday in DayManager.weekdayInEng {
            
            FirebaseManager.shared.getAllMissions(day: weekday.rawValue) { [weak self] (dailyMissions) in
                
                self?.setCellViewModel(for: dailyMissions, of: weekday.rawValue)
            }
        }
        
        completion()
    }
    
    private func setCellViewModel(for missions: [Mission], of day: String) {
        
        var cellViewModel = [MissionCellViewModel]()
        
        for mission in missions {
            
            cellViewModel.append(MissionCellViewModel(housework: mission))
        }
        
        cellViewModels[day] = cellViewModel
    }
    
}

protocol CheckMissionViewModelDelegate {
    
    
}
