//
//  DailyMissionCollectionViewCell.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/3.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class DailyMissionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dailyMissionLabel: UILabel!
    
    func layout(background color: UIColor?, mission title: String) {
        
        self.backgroundColor = color
        
        dailyMissionLabel.text = title
    }
}
