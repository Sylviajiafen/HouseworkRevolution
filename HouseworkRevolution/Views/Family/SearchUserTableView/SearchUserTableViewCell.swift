//
//  SearchUserTableViewCell.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchingMemberName: UILabel!
    
    @IBOutlet weak var searchingMemberId: UILabel!
    
    @IBAction func addMemberDidPressed(_ sender: Any) {
        
        delegate?.addMember(self)
    }
    
    weak var delegate: SearchUserTableViewCellDelegate?
    
    func layout(by member: MemberData) {
        
        searchingMemberName.text = member.name
        
        searchingMemberId.text = member.id
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

protocol SearchUserTableViewCellDelegate: AnyObject {
    
    func addMember(_ cell: SearchUserTableViewCell)
}
