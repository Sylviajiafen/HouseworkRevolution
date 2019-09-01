//
//  nameSelectionView.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/28.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class WeekdaySelectionView: UIView {
    
    @IBOutlet var contentView: UIView!
    
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
            String(describing: WeekdaySelectionView.self),
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
        
    }

}

protocol NameSelectionViewDelegate: AnyObject {
    
    func userDidSelect(at: UIButton, in view: WeekdaySelectionView)
    
    func nameCallsInLine(view: WeekdaySelectionView) -> [String]
    
}
