//
//  WishCollectionViewCell.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class WishCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var wishContent: UILabel!
    
    weak var delegate: WishCollectionViewCellDelegate?
    
    let deleteBtn = UIButton()
    
    func layOutWishLabel() {
        
        if self.bounds.height <= 100 {
            
            wishContent.font = UIFont(name: "Helvetica Bold", size: 12.0)
            
        } else if self.bounds.height < 200 {
            
            wishContent.font = UIFont(name: "Helvetica Bold", size: 14.0)
            
        } else {
            
            wishContent.font = UIFont(name: "Helvetica Bold", size: 18.0)
            
        }
    }
    
    func showDelete() {
        
        self.addSubview(deleteBtn)
        
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        deleteBtn.setImage(UIImage.asset(.deleteWish), for: .normal)
        
        deleteBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
        
        deleteBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
        deleteBtn.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        deleteBtn.heightAnchor.constraint(equalToConstant: 15).isActive = true
    
        deleteBtn.addTarget(self, action: #selector(deleteWish), for: .touchUpInside)
        
    }
    
    func blockDelete() {
        
        deleteBtn.isHidden = true
    }
    
    @objc func deleteWish() {
        
        self.delegate?.userDidHitDelete(self)
    }
}

protocol WishCollectionViewCellDelegate: AnyObject {
    
    func userDidHitDelete(_ cell: UICollectionViewCell)
}
