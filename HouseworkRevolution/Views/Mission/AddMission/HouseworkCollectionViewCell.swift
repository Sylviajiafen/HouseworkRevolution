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
    
    func setUpLabelfor(background: UIColor?, textColor: UIColor?) {
        
        guard let background = background, let textColor = textColor else { return }
        
        self.backgroundColor = background
        self.houseworkLabel.textColor = textColor
    }
    
    @IBAction func deleteHousework(_ sender: UIButton) {
        
        delegate?.deleteHousework(self)
    }
}

protocol HouseworkCollectionViewCellDelegate: AnyObject {
    
    func deleteHousework(_ cell: HouseworkCollectionViewCell)
}
