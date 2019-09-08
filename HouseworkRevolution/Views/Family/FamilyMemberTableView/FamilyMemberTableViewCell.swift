//
//  FamilyMemberTableViewCell.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class FamilyMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var memberCall: UILabel!
    @IBOutlet weak var memberId: UILabel!
    
    func setLabelColor(background: UIColor?, textColor: UIColor?, idTextColor: UIColor?, alpha: CGFloat) {
        
        guard let background = background,
              let textColor = textColor,
              let idTextColor = idTextColor else { return }
        
        memberCall.backgroundColor = background
        memberCall.textColor = textColor
        memberId.textColor = idTextColor
        memberCall.alpha = alpha
        memberId.alpha = alpha
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
