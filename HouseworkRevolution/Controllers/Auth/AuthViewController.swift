//
//  AuthViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/28.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var signUpView: UIView!
    
    @IBOutlet weak var signInView: UIView!
    
    @IBOutlet weak var userSettingView: UIView!
    
    @IBOutlet weak var nameCallSelection: UICollectionView!
    
    @IBOutlet weak var customUserName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameCallSelection.delegate = self
        
        nameCallSelection.dataSource = self
        
        signInView.isHidden = true
        
        userSettingView.isHidden = true
        
        customUserName.isHidden = true
        
    }
    
    @IBAction func showUserSetting(_ sender: Any) {
        
        userSettingView.isHidden = false
    }
    
    
    @IBAction func showSignIn(_ sender: Any) {
        
        signInView.isHidden = false
    }
    
    @IBAction func showSignUp(_ sender: Any) {
        
        signInView.isHidden = true
    }
    
    @IBAction func dissmissUserSetting(_ sender: Any) {
        
        userSettingView.isHidden = true
    }
    
    func showAlertOfNilName() {
        
        let alert = UIAlertController(title: nil, message: "自訂名稱不可空白唷！", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    let nameCalls = ["老爸", "老媽", "兒子", "女兒",
                     "爹地", "媽咪", "哥哥", "姊姊",
                     "爸爸", "媽媽", "弟弟", "妹妹",
                     "男友", "女友", "室友", "情人",
                     "自訂"]
}

extension AuthViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nameCalls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = nameCallSelection.dequeueReusableCell(
            withReuseIdentifier: "NameCallCollectionViewCell", for: indexPath)
        
        guard let nameCallItem = item as? NameCallCollectionViewCell else { return UICollectionViewCell() }
        
        nameCallItem.backgroundColor = UIColor(red: 255/255, green: 209/255, blue: 116/255, alpha: 1)
        
        nameCallItem.nameCall.text = nameCalls[indexPath.row]
        
        nameCallItem.clipsToBounds = true
        
        nameCallItem.layer.cornerRadius = 5
        
        return nameCallItem
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let nameCallItem = nameCallSelection.cellForItem(at: indexPath)
            
              as? NameCallCollectionViewCell else { return }
        
        nameCallItem.backgroundColor = UIColor(red: 255/255, green: 165/255, blue: 40/255, alpha: 1)
        
        nameCallItem.nameCall.textColor = .darkGray
        
        if indexPath.row == nameCalls.count - 1 {
            
            customUserName.isHidden = false
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let nameCallItem = nameCallSelection.cellForItem(at: indexPath)
            
            as? NameCallCollectionViewCell else { return }
        
        nameCallItem.backgroundColor = UIColor(red: 255/255, green: 209/255, blue: 116/255, alpha: 1)
        
        nameCallItem.nameCall.textColor = .white
        
        if indexPath.row == nameCalls.count - 1 {
            
            customUserName.isHidden = true
            
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    
    // 設定按下完成按鈕後若 customUserName 沒有被隱藏，而且 text 是 nil 才 showAlert
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        switch textField {
//
//        case customUserName:
//
//            if textField.text == nil {
//
//                showAlertOfNilName()
//
//            } else {
//
//                // TODO
//            }
//
//        default:
//
//            print("textFieldDidEndEditing")
//        }
//    }
}
