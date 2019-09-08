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
        
        familyMemberCollection.delegate = self
        
        familyMemberCollection.dataSource = self
        
        weekdayPicker.delegate = self
        
        weekdayPicker.dataSource = self
        
        tiredSlider.setThumbImage(UIImage(named: "icons8-heart"), for: .normal)
        
        editHouseworkBtn.isSelected = false
  
    }
    
    @IBOutlet weak var houseworksCollection: UICollectionView!
    
    @IBOutlet weak var familyMemberCollection: UICollectionView!
    
    @IBOutlet weak var addHouseworkBtn: UIButton!

    @IBOutlet weak var editHouseworkBtn: UIButton!
    
    @IBOutlet weak var customHousework: UITextField!
    
    @IBOutlet weak var weekdayPicker: UIPickerView!
    
    @IBOutlet weak var tiredSlider: UISlider!
    
    @IBOutlet weak var tiredValue: UILabel!
    
    @IBAction func userChangeTiredValue(_ sender: UISlider) {
        
        tiredValue.text = "\(Int(sender.value))"
        
    }
    
    @IBAction func addNewHousework(_ sender: UIButton) {
        
        guard let newHousework = customHousework.text else { return }
        
        guard newHousework != "" else { showAlertOfNilText(); return }
        
        houseworks.append(newHousework)
    
    }
    
    @IBAction func createHousework(_ sender: UIButton) {
        
        // TODO: 將任務存到雲端
        
        self.dismiss(animated: true, completion: nil)
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
    
    // TODO: 從雲端抓取
    var familyMember: [String] = ["(自己)"]
    
    var weekday: [Weekdays] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
    
    // TODO: 從雲端抓取，存入變數
    // 預設家事標籤的array存在專案裡，並搭配圖
    // 在一開始 viewWillAppear fetch database 使用者的家事標籤，（如果有家事標籤array的話才）把 houseworks 洗掉(會進didSet)，沒有的話就不抓 dataBase
    // 預設家事標籤用 enum 存，並去判斷搭配的圖
    
    var houseworks: [String] = ["掃地", "拖地", "倒垃圾", "洗衣服", "煮飯", "買菜", "掃廁所"] {
        
        didSet {
            print("======== 家事標籤 didSet")
            
            houseworksCollection.reloadData()
            
            // TODO: 更新雲端（新增(使用者有更改這個 array 時才讓 dataBase 存一個家事標籤 array，並把這些預設的一起存進去) 或 洗掉原本的array）
        }
    }
    
    var shouldEditCell: Bool = false {
        
        didSet {
            
            houseworksCollection.reloadData()
        }
    }
    
    func showAlertOfNilText() {
        
        let alert = UIAlertController(title: nil, message: "欄位留白囉", preferredStyle: .alert)
        
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

}

extension AddMissionViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    HouseworkCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        
        switch collectionView {
            
        case houseworksCollection:
            
            return houseworks.count
        
        case familyMemberCollection:
            
            return familyMember.count
            
        default: return 1
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
        
    ) -> UICollectionViewCell {
        
        switch collectionView {
        
        case houseworksCollection:
            
            let cell = houseworksCollection.dequeueReusableCell(
                withReuseIdentifier: String(describing: HouseworkCollectionViewCell.self), for: indexPath)
            
            guard let houseworkCell = cell as? HouseworkCollectionViewCell else { return UICollectionViewCell() }
            
            houseworkCell.setUpLabelfor(background: UIColor.buttonUnSelected, textColor: .white)
            
            houseworkCell.houseworkLabel.text = houseworks[indexPath.row]
            
            houseworkCell.delegate = self
            
            if shouldEditCell == true {
                    
                houseworkCell.deleteCellBtn.isHidden = false
                
            } else {
                
                houseworkCell.deleteCellBtn.isHidden = true
            }
            
            return houseworkCell
            
        case familyMemberCollection:
            
            let cell = familyMemberCollection.dequeueReusableCell(
                withReuseIdentifier: String(describing: FamilyMemberCollectionViewCell.self), for: indexPath)
            
            guard let familyCell = cell as? FamilyMemberCollectionViewCell else { return UICollectionViewCell() }
            
            familyCell.setUpLabelfor(background: UIColor.buttonUnSelected, textColor: UIColor.white)
            
            familyCell.memberLabel.text = familyMember[indexPath.row]
            
            return familyCell
            
        default:
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case houseworksCollection:
            
            guard let houseworkCell = houseworksCollection.cellForItem(at: indexPath)
                
                as? HouseworkCollectionViewCell else { return }
            
            houseworkCell.setUpLabelfor(background: UIColor.buttonSelected, textColor: UIColor.noticeGray)
            
        case familyMemberCollection:
            
            guard let familyCell = familyMemberCollection.cellForItem(at: indexPath)
                
                as? FamilyMemberCollectionViewCell else { return }
            
            familyCell.setUpLabelfor(background: UIColor.buttonSelected, textColor: UIColor.noticeGray)
            
        default:
            
            return
        }
        
        // TODO: 把使用者選的值存進一變數中，還是要 switch collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case houseworksCollection:
            
            guard let houseworkCell = houseworksCollection.cellForItem(at: indexPath)
                
                as? HouseworkCollectionViewCell else { return }
            
            houseworkCell.setUpLabelfor(background: UIColor.buttonUnSelected, textColor: .white)
        
        case familyMemberCollection:
            
            guard let familyCell = familyMemberCollection.cellForItem(at: indexPath)
                
                as? FamilyMemberCollectionViewCell else { return }
            
            familyCell.setUpLabelfor(background: UIColor.buttonUnSelected, textColor: UIColor.white)
            
        default:
            
            return
        }
        
    }
    
    func deleteHousework(_ cell: HouseworkCollectionViewCell) {
        
        guard let index = houseworksCollection.indexPath(for: cell) else { return }
        
        houseworks.remove(at: index.item)
        
        shouldEditCell = false
        
        editHouseworkBtn.isSelected = false
        
    }
    
}
