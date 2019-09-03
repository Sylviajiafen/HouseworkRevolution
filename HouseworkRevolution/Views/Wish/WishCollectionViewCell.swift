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
    
    @IBOutlet weak var wishView: UIView!
    
    weak var delegate: WishCollectionViewCellDelegate?
    
    let deleteBtn = UIButton()
    
    func showDelete() {
        
        // TODO: 改圖
        let image = UIImage(named: "delete-file-from-cloud")
        
        self.addSubview(deleteBtn)
        
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        deleteBtn.setImage(image, for: .normal)
        
        deleteBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        
        deleteBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
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
