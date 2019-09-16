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
        
        houseworksCollection.delegate = self
        
        houseworksCollection.dataSource = self
        
        weekdayPicker.delegate = self
        
        weekdayPicker.dataSource = self
        
        tiredSlider.setThumbImage(UIImage(named: "valueHeart"), for: .normal)
        
        editHouseworkBtn.isSelected = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        FirebaseUserHelper.shared.readLabelsOf(
        
        family: StorageManager.userInfo.familyID) { [weak self] (labels) in
            
            for label in labels {
                
                self?.houseworks.append(label)
            }
        }
    }
    
    @IBOutlet weak var houseworksCollection: UICollectionView!

    @IBOutlet weak var editHouseworkBtn: UIButton!
    
    @IBOutlet weak var customHousework: UITextField!
    
    @IBOutlet weak var weekdayPicker: UIPickerView!
    
    @IBOutlet weak var tiredSlider: UISlider!
    
    @IBOutlet weak var tiredValue: UILabel!
    
    var weekday: [Weekdays] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
    
    var weekdayInEng: [WeekdayInEng] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
    
    var houseworks: [String] =
        
        [DefaultHouseworks.sweep.rawValue,
         DefaultHouseworks.mop.rawValue,
         DefaultHouseworks.vacuum.rawValue,
         DefaultHouseworks.garbadge.rawValue,
         DefaultHouseworks.laundry.rawValue,
         DefaultHouseworks.cook.rawValue,
         DefaultHouseworks.grocery.rawValue,
         DefaultHouseworks.toilet.rawValue] {
        
        didSet {
            
            houseworksCollection.reloadData()
            selectedIndex = nil
        }
    }
    
    var shouldEditCell: Bool = false {
        
        didSet {
            
            houseworksCollection.reloadData()
            selectedIndex = nil
        }
    }
    
    var selectedIndex: Int?
    
    var tiredValueInNum: Int?
    
    var selectedDay: String = DayManager.shared.weekday
    
    @IBAction func userChangeTiredValue(_ sender: UISlider) {
        
        tiredValue.text = "\(Int(sender.value))"
        
        tiredValueInNum = Int(sender.value)
    }
    
    @IBAction func addNewLabel(_ sender: UIButton) {
        
        guard let newHousework = customHousework.text else { return }
        
        guard newHousework != "" else { showAlertOf(message: "欄位留白囉"); return }
        
        houseworks.append(newHousework)
        
        FirebaseUserHelper.shared.addLabelOf(content: newHousework,
                                             family: StorageManager.userInfo.familyID)
    
        customHousework.text = ""
    }
    
    @IBAction func createHousework(_ sender: UIButton) {
        
        if selectedIndex == nil {
            
            showAlertOf(message: "請選擇家事標籤")
            
        } else {
            
            guard let selectedIndex = selectedIndex,
                let tiredValue = tiredValueInNum else { showAlertOf(message: "資訊不完整呢 ><"); return }
            
            FirebaseManager.shared.addMissionToHouseworks(
                title: houseworks[selectedIndex],
                tiredValue: tiredValue,
                weekday: selectedDay,
                family: StorageManager.userInfo.familyID)
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func editCell(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        
        if sender.isSelected == true {
        
            shouldEditCell = true
            
        } else {
            
            shouldEditCell = false
        }
    }
    
    @IBAction func backToRoot(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlertOf(message: String) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel)
        
        action.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}

extension AddMissionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int
        
    ) -> Int { return weekday.count }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        pickerLabel.font = UIFont(name: "Helvetica Neue", size: 17.0)
        
        pickerLabel.textColor = UIColor.noticeGray
        
        pickerLabel.text = weekday[row].rawValue
        
        pickerLabel.textAlignment = .center
        
        pickerLabel.backgroundColor = .white
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        selectedDay = weekdayInEng[row].rawValue
    }
}

extension AddMissionViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    HouseworkCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        
        return houseworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
        
    ) -> UICollectionViewCell {
        
        let cell = houseworksCollection.dequeueReusableCell(
                withReuseIdentifier: String(describing: HouseworkCollectionViewCell.self), for: indexPath)
            
        guard let houseworkCell = cell as? HouseworkCollectionViewCell else { return UICollectionViewCell() }
            
        houseworkCell.setUpLabelfor(background: UIColor.buttonUnSelected, textColor: .white)
            
        houseworkCell.houseworkLabel.text = houseworks[indexPath.row]
            
        houseworkCell.delegate = self
            
        if shouldEditCell == true {
            
            if indexPath.row > 7 {
                
                houseworkCell.deleteCellBtn.isHidden = false
                
            } else {
                
                houseworkCell.deleteCellBtn.isHidden = true
            }
                
        } else {
                
            houseworkCell.deleteCellBtn.isHidden = true
        }
            
        return houseworkCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        guard let houseworkCell = houseworksCollection.cellForItem(at: indexPath)
                                    as? HouseworkCollectionViewCell else { return }
            
        houseworkCell.setUpLabelfor(background: UIColor.buttonSelected, textColor: UIColor.noticeGray)
            
        selectedIndex = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            
        guard let houseworkCell = houseworksCollection.cellForItem(at: indexPath)
                                    as? HouseworkCollectionViewCell else { return }
            
        houseworkCell.setUpLabelfor(background: UIColor.buttonUnSelected, textColor: .white)
        
    }
    
    func deleteHousework(_ cell: HouseworkCollectionViewCell) {
        
        guard let index = houseworksCollection.indexPath(for: cell) else { return }
        
        FirebaseUserHelper.shared.removeLabelOf(content: houseworks[index.item],
                                                family: StorageManager.userInfo.familyID)
        houseworks.remove(at: index.item)
        
        shouldEditCell = false
        
        editHouseworkBtn.isSelected = false
        
    }
    
}
