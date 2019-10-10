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
    
    @IBOutlet weak var cancelInvitationBtn: UIButton!
    
    weak var delegate: FamilyMemberTableViewCellDelegate?
    
//    func setLabelColor(background: UIColor?,
//                       textColor: UIColor?,
//                       idTextColor: UIColor?,
//                       alpha: CGFloat) {
//        
//        guard let background = background,
//              let textColor = textColor,
//              let idTextColor = idTextColor else { return }
//        
//        memberCall.backgroundColor = background
//        
//        memberCall.textColor = textColor
//        
//        memberId.textColor = idTextColor
//        
//        memberCall.alpha = alpha
//        
//        memberId.alpha = alpha
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func cancelInvitation(_ sender: Any) {
        
        self.delegate?.cancelInvitation(self)
    }
    
    func layoutCell(with member: MemberData,
                    textColor: UIColor?,
                    alpha: CGFloat,
                    hideCancel: Bool) {
        
        guard let textColor = textColor,
              let background = UIColor.buttonUnSelected else { return }
               
        memberCall.backgroundColor = background
               
        memberCall.textColor = textColor
               
        memberId.textColor = .lightGray
               
        memberCall.alpha = alpha
               
        memberId.alpha = alpha
        
        memberCall.text = member.name
        
        memberId.text = member.id
        
        cancelInvitationBtn.isHidden = hideCancel
    }
}

protocol FamilyMemberTableViewCellDelegate: AnyObject {
    
    func cancelInvitation(_ cell: FamilyMemberTableViewCell)
}
