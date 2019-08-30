//
//  AddMissionViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/29.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class AddMissionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekdayPicker.delegate = self
        
        weekdayPicker.dataSource = self
        
        weekdayPicker.tintColor = .darkGray
        
        tiredSlider.setThumbImage(UIImage(named: "icons8-heart"), for: .normal)
    
    }

    @IBOutlet weak var addHouseworkBtn: UIButton!
    
    @IBOutlet weak var customHousework: UITextField!
    
    @IBOutlet weak var weekdayPicker: UIPickerView!
    
    @IBOutlet weak var tiredSlider: UISlider!
    
    @IBOutlet weak var tiredValue: UILabel!
    
    @IBAction func userChangeTiredValue(_ sender: UISlider) {
        
        tiredValue.text = "\(Int(sender.value))"
        
    }
    
    var weekday: [Weekdays] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
    
    var houseworks: [String] = ["打掃", "倒垃圾", "洗衣服", "做便當", "買菜", "清冰箱"] {
        
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
    
    func setUpPicker() {
        
        weekdayPicker.tintColor = .darkGray
    }
    
}

extension AddMissionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int
        
    ) -> Int { return 7 }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        pickerLabel.font = UIFont(name: "Helvetica Neue", size: 15.0)
        
        pickerLabel.textColor = UIColor.noticeGray
        
        pickerLabel.text = weekday[row].rawValue
        
        pickerLabel.textAlignment = .center
        
        return pickerLabel
        
    }

}
