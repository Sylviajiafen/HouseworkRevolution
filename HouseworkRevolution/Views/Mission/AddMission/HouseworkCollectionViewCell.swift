//
//  HouseworkCollectionViewCell.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class HouseworkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var houseworkLabel: UILabel!
    
    @IBOutlet weak var deleteCellBtn: UIButton!
    
    weak var delegate: HouseworkCollectionViewCellDelegate?
    
    func setUpLabelFor(background: UIColor?, textColor: UIColor?) {
        
        guard let background = background, let textColor = textColor else { return }
        
        self.backgroundColor = background
        
        self.houseworkLabel.textColor = textColor
    }
    
    func initial(with housework: String? = nil) {
        
        self.backgroundColor = UIColor.buttonUnSelected
        
        self.houseworkLabel.textColor = .white
        
        if housework != nil {
            
            houseworkLabel.text = housework
        }
    }
    
    func setDeleteIcon(at index: Int, by shouldEdit: Bool) {
        
        if shouldEdit == true {
            
            if index > 7 {
                
                deleteCellBtn.isHidden = false
                
            } else {
                
                deleteCellBtn.isHidden = true
            }
                
        } else {
                
           deleteCellBtn.isHidden = true
        }
    }
    
    @IBAction func deleteHousework(_ sender: UIButton) {
        
        delegate?.deleteHousework(self)
    }
}

protocol HouseworkCollectionViewCellDelegate: AnyObject {
    
    func deleteHousework(_ cell: HouseworkCollectionViewCell)
}
