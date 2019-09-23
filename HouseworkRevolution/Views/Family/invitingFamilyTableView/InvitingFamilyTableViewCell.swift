//
//  InvitingFamilyTableViewCell.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class InvitingFamilyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var invitingPersonLabel: UILabel!
    
    @IBOutlet weak var invitingFamilyName: UILabel!
    
    weak var delegate: InvitingFamilyTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func accept(_ sender: Any) {
        
        self.delegate?.acceptInvitation(self)
    }
    
    @IBAction func reject(_ sender: Any) {
        
        self.delegate?.rejectInvitation(self)
    }
    
}

protocol InvitingFamilyTableViewCellDelegate: AnyObject {
    
    func acceptInvitation(_ cell: InvitingFamilyTableViewCell)
    
    func rejectInvitation(_ cell: InvitingFamilyTableViewCell)
}
