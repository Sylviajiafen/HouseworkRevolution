//
//  nameSelectionView.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/28.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class NameSelectionView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var firstLeftBtn: UIButton!
    
    @IBOutlet weak var secondLeftBtn: UIButton!
    
    @IBOutlet weak var secondRightBtn: UIButton!
    
    @IBOutlet weak var firstRightBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initContentView()
    }
    
    private func initContentView() {
        
        backgroundColor = .white
        
        Bundle.main.loadNibNamed(
            String(describing: NameSelectionView.self),
            owner: self,
            options: nil)

        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    weak var delegate: NameSelectionViewDelegate? {
        
        didSet {
            
            layoutNameCalls()

        }
    }
    
    func layoutNameCalls() {
        
        guard let delegate = self.delegate else { return }
        
        let calls = delegate.nameCallsInLine(view: self)
        
        firstLeftBtn.setTitle(calls[0], for: .normal)
        
        secondLeftBtn.setTitle(calls[1], for: .normal)
        
        secondRightBtn.setTitle(calls[2], for: .normal)
        
        firstRightBtn.setTitle(calls[3], for: .normal)
        
    }

}

protocol NameSelectionViewDelegate: AnyObject {
    
    func userDidSelect(at: UIButton, in view: NameSelectionView)
    
    func nameCallsInLine(view: NameSelectionView) -> [String]
    
}
