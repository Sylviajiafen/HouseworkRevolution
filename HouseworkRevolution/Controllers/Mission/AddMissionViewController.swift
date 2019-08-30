//
//  AddMissionViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/29.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class AddMissionViewController: UIViewController {

    @IBOutlet weak var addHouseworkBtn: UIButton!
    
    @IBOutlet weak var customHousework: UITextField!
    
    @IBOutlet weak var tiredSlider: UISlider!
    
    @IBOutlet weak var tiredValue: UILabel!
    
    @IBAction func userChangeTiredValue(_ sender: UISlider) {
        
        tiredValue.text = "\(Int(sender.value))"
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tiredSlider.setThumbImage(UIImage(named: "icons8-heart"), for: .normal)
    }
    
    var houseworks: [String] = [] {
        
        didSet {
            
            setUpHouseworkBtn()
            
        }
    }
    
    func setUpHouseworkBtn() {
        
        if houseworks.count >= 12 {
            
            addHouseworkBtn.setTitle("移除", for: .normal)
            
            customHousework.isHidden = true
            
        } else {
            
            addHouseworkBtn.setTitle("新增家事標籤", for: .normal)
            
            customHousework.isHidden = false
            
        }
    }
    
}
