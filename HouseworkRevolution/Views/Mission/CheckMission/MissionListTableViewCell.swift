//
//  MissionListTableViewCell.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class MissionListTableViewCell: UITableViewCell {
    
    weak var delegate: MissionListTableViewCellDelegate?

    @IBOutlet weak var missionLabel: UILabel!
    
    @IBOutlet weak var houseworkIcon: UIImageView!
    
    @IBOutlet weak var tiredValueLabel: UILabel!
    
    @IBAction func removeDidPressed(_ sender: Any) {
        
        delegate?.removeMission(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setIcon(by mission: Mission) {
        
        switch mission.title {
            
        case DefaultHouseworks.sweep.rawValue:
            
            houseworkIcon.image = UIImage.asset(.cleanFloorICON)
            
        case DefaultHouseworks.mop.rawValue:
            
            houseworkIcon.image = UIImage.asset(.mopICON)
            
        case DefaultHouseworks.vacuum.rawValue:
            
            houseworkIcon.image = UIImage.asset(.vacuumICON)
            
        case DefaultHouseworks.garbadge.rawValue:
            
            houseworkIcon.image = UIImage.asset(.garbageICON)
        
        case DefaultHouseworks.laundry.rawValue:
            
            houseworkIcon.image = UIImage.asset(.laundryICON)
            
        case DefaultHouseworks.cook.rawValue:
            
            houseworkIcon.image = UIImage.asset(.cookICON)
            
        case DefaultHouseworks.grocery.rawValue:
            
            houseworkIcon.image = UIImage.asset(.groceryICON)
            
        case DefaultHouseworks.toilet.rawValue:
            
            houseworkIcon.image = UIImage.asset(.cleanToiletICON)
            
        default:
            
            houseworkIcon.image = UIImage.asset(.customWorkICON)
        }
    }

}

protocol MissionListTableViewCellDelegate: AnyObject {
    
    func removeMission(_ cell: MissionListTableViewCell)
}
