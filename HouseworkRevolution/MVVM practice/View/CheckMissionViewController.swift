//
//  CheckMissionViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/29.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class CheckMissionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressHUD.show(self.view)
        
        mainViewModel.delegate = self
        
        mainViewModel.getMissions { [weak self] in
            
            DispatchQueue.main.async {
                
                self?.missionListTableView.reloadData()
                
                ProgressHUD.dismiss()
            }
        }
    }
    
    let mainViewModel = CheckMissionViewModel()
    
    func setUpTableView() {
        
        missionListTableView.delegate = self
        
        missionListTableView.dataSource = self
        
        missionListTableView.backgroundColor = UIColor.projectBackground
        
        // MARK: regist header
        let headerXib = UINib(nibName: String(describing: WeekdaySectionHeaderView.self),
                              bundle: nil)
        
        missionListTableView.register(headerXib,
                                      forHeaderFooterViewReuseIdentifier:
                                        String(describing: WeekdaySectionHeaderView.self))
        
        missionListTableView.addPullToRefresh(missionListTableView) {  [weak self] in
            
        self?.mainViewModel.getMissions { [weak self] in
                
            DispatchQueue.main.async {
                    
                guard let strongSelf = self else { return }
                strongSelf.missionListTableView.reloadData()
                    
                strongSelf.missionListTableView.endPullToRefresh(strongSelf.missionListTableView)
            }
        }
//            for weekdays in DayManager.weekdayInEng {
//
//                FirebaseManager.shared.getAllMissions(day: weekdays.rawValue
//                ) { [weak self] (dailyMission) in
//
//                    guard let strongSelf = self else { return }
//
//                    DispatchQueue.main.async {
//
//                        strongSelf.missionListTableView.reloadData()
//
//                        strongSelf.missionListTableView
//                            .endPullToRefresh(strongSelf.missionListTableView)
//                    }
//                }
//            }
        }
    }
    
    @IBOutlet weak var missionListTableView: UITableView! {
        
        didSet {
            
            setUpTableView()
        }
    }
    
    @IBAction func backToRoot(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension CheckMissionViewController: UITableViewDelegate,
                                      UITableViewDataSource,
                                      MissionListTableViewCellDelegate {
  
    // MARK: Section Header
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return DayManager.weekdayInEng.count
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int
    ) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int
    ) -> CGFloat {
        
        return 10.0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int
    ) -> UIView? {
        
        guard let header = missionListTableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: WeekdaySectionHeaderView.self))
            as? WeekdaySectionHeaderView else { return nil }
        
        let day = DayManager.weekdayInEng[section]
        
        header.weekdayLabel.text = day.inChinese
        
        return header
    }
    
    // MARK: TableView Cell
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        
        let day = DayManager.weekdayInEng[section].rawValue

        let viewModels = mainViewModel.cellViewModels
        
        guard let missionOfDay = viewModels[day] else { return 0 }
    
        if missionOfDay.count == 0 {
            
            return 1
            
        } else {
            
            return missionOfDay.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
    
        let day = DayManager.weekdayInEng[indexPath.section].rawValue
        
        let viewModels = mainViewModel.cellViewModels
        
        if let missionOfDay = viewModels[day] {
            
            if missionOfDay.count > 0 {

                let cell = missionListTableView.dequeueReusableCell(
                        withIdentifier: String(describing: MissionListTableViewCell.self),
                        for: indexPath)

                guard let mission = cell as? MissionListTableViewCell else { return UITableViewCell() }

                mission.setBy(viewModel: missionOfDay[indexPath.row])

                mission.delegate = self

                return mission
                
            } else {
                
                let cell = missionListTableView.dequeueReusableCell(
                    withIdentifier: String(describing: MissionEmptyTableViewCell.self),
                    for: indexPath)
                
                guard let emptyMission = cell
                    as? MissionEmptyTableViewCell else { return UITableViewCell() }
                
                return emptyMission
            }

        } else {
            
            return UITableViewCell()
        }
        
    }
    
    // MARK: - Remove Mission
    func removeMission(_ cell: MissionListTableViewCell) {
        
//        guard let index = missionListTableView.indexPath(for: cell),
//            let missionOfDay = FirebaseManager.allMission[DayManager.weekdayInEng[index.section].rawValue]
//            else { return }
        
//        let toBeRemovedMission = missionOfDay[index.row]
 
//        FirebaseManager.allMission[DayManager.weekdayInEng[index.section].rawValue]?
//                       .remove(at: index.row)
//
//        FirebaseManager.shared.deleteMissionFromHouseworks(title: toBeRemovedMission.title,
//                                                           tiredValue: toBeRemovedMission.tiredValue,
//                                                           weekday: DayManager.weekdayInEng[index.section].rawValue)
//
//        DispatchQueue.main.async { [weak self] in
//
//            self?.missionListTableView.reloadData()
//        }
        
        guard let index = missionListTableView.indexPath(for: cell) else { return }
        
        mainViewModel.delete(mission: index.row, day: index.section)
    }
}

extension CheckMissionViewController: CheckMissionViewModelDelegate {
    
    func missionDeleted(_ viewModel: CheckMissionViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.missionListTableView.reloadData()
            
        }
    }
}
