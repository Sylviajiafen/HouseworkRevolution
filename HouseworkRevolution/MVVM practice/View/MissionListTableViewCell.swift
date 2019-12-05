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
    
    func setBy(viewModel: MissionCellViewModel) {
        
        viewModel.configure(self)
    }
}

protocol MissionListTableViewCellDelegate: AnyObject {
    
    func removeMission(_ cell: MissionListTableViewCell)
}
