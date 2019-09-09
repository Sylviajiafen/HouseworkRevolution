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
        
        missionListTableView.delegate = self
        missionListTableView.dataSource = self
        missionListTableView.backgroundColor = UIColor.projectBackground
        
        // 的TODO: 預設的家事標籤搭配圖
        missionOfWeek = ["Monday": ["掃地", "洗衣"],
                         "Tuesday": ["鏟貓砂", "洗碗", "煮飯"]]
        
        // MARK: regist header
        let headerXib = UINib(nibName: String(describing: WeekdaySectionHeaderView.self), bundle: nil)
        
        missionListTableView.register(headerXib, forHeaderFooterViewReuseIdentifier: String(describing: WeekdaySectionHeaderView.self))
    }
    
    @IBOutlet weak var missionListTableView: UITableView!
    
    @IBAction func backToRoot(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // TODO: 跟 dataBase 要一週任務，放進變數中，要放pull refresh
    var missionOfWeek = [String: [String]]()
    
    var weekday: [Weekdays] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
}

extension CheckMissionViewController: UITableViewDelegate,
                                      UITableViewDataSource,
MissionListTableViewCellDelegate {
  
    // MARK: Section Header
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return weekday.count
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int
    ) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int
    ) -> UIView? {
        
        guard let header = missionListTableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: WeekdaySectionHeaderView.self))
            as? WeekdaySectionHeaderView else { return nil }
             
        header.weekdayLabel.text = weekday[section].rawValue
        
        return header
    }
    
    // MARK: TableView Cell
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        
        guard let missionOfDay = missionOfWeek[changeSectionIntoWeekday(section)] else { return 1 }
        
        return missionOfDay.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        if let missionOfDay = missionOfWeek[changeSectionIntoWeekday(indexPath.section)] {
            
            let cell = missionListTableView.dequeueReusableCell(
                withIdentifier: String(describing: MissionListTableViewCell.self), for: indexPath)
            
            guard let mission = cell as? MissionListTableViewCell else { return UITableViewCell() }
            
            mission.missionLabel.text = missionOfDay[indexPath.row]
            
            mission.delegate = self
            
            return mission
            
        } else {
            
            let cell = missionListTableView.dequeueReusableCell(
                withIdentifier: String(describing: MissionEmptyTableViewCell.self), for: indexPath)
            
            guard let emptyMission = cell as? MissionEmptyTableViewCell else { return UITableViewCell() }
            
            return emptyMission
        }
    }
    
    func changeSectionIntoWeekday(_ section: Int) -> String {
        
        switch section {
            
        case 0:
            return "Monday"
        
        case 1:
            return "Tuesday"
            
        case 2:
            return "Wednesday"
            
        case 3:
            return "Thursday"
            
        case 4:
            return "Friday"
            
        case 5:
            return "Saturday"

        case 6:
            return "Sunday"
            
        default:
            return ""
        }
    }
    
    // Mark: Remove Mission
    func removeMission(_ cell: MissionListTableViewCell) {
        
        guard let index = missionListTableView.indexPath(for: cell) else { return }
        
        missionOfWeek[changeSectionIntoWeekday(index.section)]?.remove(at: index.row)
        
        missionListTableView.deleteRows(at: [index], with: .middle)
        
        //TODO: 更新dataBase
    }
}

//TODO: 若建立 Firebase 時存入的家事時間直接是 0 - 6，則不需轉換，dictionary 變數變為 「[Int: [String]]」
