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
    
    weak var delegate: CheckMissionViewModelDelegate?
    
    var cellViewModels = [WeekdayInEng.Monday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Tuesday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Wednesday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Thursday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Friday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Saturday.rawValue: [MissionCellViewModel](),
                          WeekdayInEng.Sunday.rawValue: [MissionCellViewModel]()]
    
    var viewModelsReady: (() -> Void)?
    
    func getMissions(completion: @escaping () -> Void) {
        
        let group = DispatchGroup()
        
        for weekday in DayManager.weekdayInEng {
            
            group.enter()
            
            FirebaseManager.shared.getAllMissions(day: weekday.rawValue) { [weak self] (dailyMissions) in
                
                self?.setCellViewModel(for: dailyMissions,
                                       of: weekday.rawValue)
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            
            completion()
        }
    }
    
    private func setCellViewModel(for missions: [Mission],
                                  of day: String) {
        
        var cellViewModel = [MissionCellViewModel]()
        
        for mission in missions {
            
            cellViewModel.append(MissionCellViewModel(housework: mission))
        }
        
        cellViewModels[day] = cellViewModel
    }
    
    func delete(mission index: Int, day onIndex: Int) {
        
        let weekday = DayManager.weekdayInEng[onIndex].rawValue
        
        guard let missionsOnDay = cellViewModels[weekday] else { return }
                
        let mission = missionsOnDay[index]
        
        FirebaseManager.shared.deleteMissionFromHouseworks(title: mission.title,
                                                           tiredValue: mission.tiredValue,
                                                           weekday: weekday)
        
        cellViewModels[weekday]?.remove(at: index)
        
        self.delegate?.missionDeleted(self)
    }
}

protocol CheckMissionViewModelDelegate: AnyObject {
    
    func missionDeleted(_ viewModel: CheckMissionViewModel)
}
