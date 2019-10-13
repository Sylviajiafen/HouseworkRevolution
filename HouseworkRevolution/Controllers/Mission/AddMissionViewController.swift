//
//  AddMissionViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/29.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class AddMissionViewController: TextCountLimitBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tiredSlider.setThumbImage(UIImage.asset(.valueHeart), for: .normal)
        
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
    
    @IBOutlet weak var houseworksCollection: UICollectionView! {
        
        didSet {
            
            houseworksCollection.delegate = self
            
            houseworksCollection.dataSource = self
        }
    }

    @IBOutlet weak var editHouseworkBtn: UIButton!
    
    @IBOutlet weak var customHousework: UITextField! {
        
        didSet {
            
            customHousework.delegate = self
        }
    }
    
    @IBOutlet weak var weekdayPicker: UIPickerView! {
        
        didSet {
            
            weekdayPicker.delegate = self
                   
            weekdayPicker.dataSource = self
        }
    }
    
    @IBOutlet weak var tiredSlider: UISlider!
    
    @IBOutlet weak var tiredValue: UILabel!
    
    override var textLimitCount: Int { return 8 }
    
    var houseworks: [String] =
        [DefaultHouseworks.sweep.rawValue,
         DefaultHouseworks.mop.rawValue,
         DefaultHouseworks.vacuum.rawValue,
         DefaultHouseworks.garbage.rawValue,
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
    
    var tiredValueInNum: Int = 0
    
    var selectedDay: String = WeekdayInEng.Monday.rawValue
    
    @IBAction func userChangeTiredValue(_ sender: UISlider) {
        
        tiredValue.text = "\(Int(sender.value))"
        
        tiredValueInNum = Int(sender.value)
    }
    
    @IBAction func addNewLabel(_ sender: UIButton) {
        
        guard let newHousework = customHousework.text else { return }
        
        guard newHousework != "" else { showAlertOf(message: "欄位留白囉"); return }
        
        if houseworks.contains(newHousework) {

            showAlertOf(message: "已有「\(newHousework)」的家事標籤")

            customHousework.clearText()

            return

        } else {
            
            houseworks.append(newHousework)
                
            FirebaseUserHelper.shared.addLabelOf(newHousework)
            
            customHousework.clearText()
        }
        
    }
    
    @IBAction func createHousework(_ sender: UIButton) {
        
        if selectedIndex == nil {
            
            showAlertOf(message: "請選擇家事標籤")
            
        } else {
            
            guard let selectedIndex = selectedIndex else {
                
                showAlertOf(message: "資訊不完整呢 ><")
                
                return
            }
            
            ProgressHUD.show(self.view)
            
            FirebaseManager.shared.addMissionToHouseworks(
                title: houseworks[selectedIndex],
                tiredValue: tiredValueInNum,
                weekday: selectedDay,
                message: { [weak self] message in
                    
                    switch message {
                        
                    case .duplicated(let message):
                        
                        self?.showAlertOf(message: message, dismissByCondition: true,
                                          handler: { [weak self] in
                            
                            self?.dismiss(animated: true, completion: nil)
                        })
                        
                    case .success(let message):
                        
                        ProgressHUD.dismiss()
                        
                        self?.dismiss(animated: true, completion: {
                            
                            ProgressHUD.showＷith(text: message)
                        })
                        
                    case .failed(let failed):
                        
                        print(failed)
                    }
            })
        }
    }
    
    @IBAction func editCell(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        
        shouldEditCell = sender.isSelected
    }
    
    @IBAction func backToRoot(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AddMissionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int
        
    ) -> Int {
        
        return DayManager.weekdayInCH.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        
        return viewForPicker(of: DayManager.weekdayInCH[row])
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        selectedDay = DayManager.weekdayInEng[row].rawValue
    }
    
    private func viewForPicker(of weekday: Weekdays) -> UILabel {
        
        let pickerLabel = UILabel()
        
        pickerLabel.font = UIFont(name: "Helvetica Neue", size: 17.0)
        
        pickerLabel.textColor = UIColor.noticeGray
        
        pickerLabel.text = weekday.rawValue
        
        pickerLabel.textAlignment = .center
        
        pickerLabel.backgroundColor = .white
        
        return pickerLabel
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
                withReuseIdentifier: String(describing: HouseworkCollectionViewCell.self),
                for: indexPath)
            
        guard let houseworkCell = cell as? HouseworkCollectionViewCell else { return UICollectionViewCell() }
            
        houseworkCell.initial(with: houseworks[indexPath.row])
        
        houseworkCell.setDeleteIcon(at: indexPath.row, by: shouldEditCell)
            
        houseworkCell.delegate = self
            
        return houseworkCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath
    ) {
            
        guard let houseworkCell = houseworksCollection.cellForItem(at: indexPath)
                as? HouseworkCollectionViewCell else { return }
            
        houseworkCell.setUpLabelFor(background: UIColor.buttonSelected,
                                    textColor: UIColor.noticeGray)
            
        selectedIndex = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath
    ) {
            
        guard let houseworkCell = houseworksCollection.cellForItem(at: indexPath)
                as? HouseworkCollectionViewCell else { return }
            
        houseworkCell.initial()
    }
    
    func deleteHousework(_ cell: HouseworkCollectionViewCell) {
        
        guard let index = houseworksCollection.indexPath(for: cell) else { return }
        
        FirebaseUserHelper.shared.removeLabelOf(content: houseworks[index.item])
        
        houseworks.remove(at: index.item)
        
        shouldEditCell = false
        
        editHouseworkBtn.isSelected = false
    }
    
}
