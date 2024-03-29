//
//  FamilyMemberCollectionViewCell.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class FamilyMemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memberLabel: UILabel!
    
    func setUpLabelfor(background: UIColor?, textColor: UIColor?) {
        
        guard let background = background, let textColor = textColor else { return }
        
        self.backgroundColor = background
        self.memberLabel.textColor = textColor
    }
}
