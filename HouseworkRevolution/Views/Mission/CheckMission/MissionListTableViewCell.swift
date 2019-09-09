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
    
     // TODO: 寫移除家事的 func，更新 dataBase
    @IBAction func removeDidPressed(_ sender: Any) {
        
        delegate?.removeMission(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol MissionListTableViewCellDelegate: AnyObject {
    
    func removeMission(_ cell: MissionListTableViewCell)
}
