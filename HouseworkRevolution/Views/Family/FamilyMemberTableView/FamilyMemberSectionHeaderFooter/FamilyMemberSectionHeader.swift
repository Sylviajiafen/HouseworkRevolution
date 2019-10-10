//
//  FamilyMemberSectionHeader.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class FamilyMemberSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    @IBOutlet weak var sectionContentView: UIView!
    
    private func addCorner() {
        
        sectionContentView.clipsToBounds = true
        
        sectionContentView.layer.cornerRadius = 8
        
        sectionContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func layoutOf(title: String) {
        
        self.addCorner()
        
        sectionTitleLabel.text = title
    }
    
}
