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
    
    @IBOutlet weak var createPassword: UITextField!
    
    @IBOutlet weak var createHomeName: UITextField!
    
    @IBOutlet weak var userID: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameCallSelection.delegate = self
        
        nameCallSelection.dataSource = self
        
        signInView.isHidden = true
        
        userSettingView.isHidden = true
        
        customUserName.isHidden = true
        
    }
    
    @IBAction func showUserSetting(_ sender: Any) {
        
        if createPassword.text == "" {
            
            showAlertOfNilText()
        
        } else {
        
            userSettingView.isHidden = false
         
            // TODO: 建一筆新資料存到 dataBase
        }
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
    
    func showAlertOfNilText() {
        
        let alert = UIAlertController(title: nil, message: "欄位留白囉", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func showShouldSelect() {
            
            let alert = UIAlertController(title: nil, message: "選擇一個稱呼後才能建立家唷", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .cancel)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        
    }
    
    var selectedNameIndex: Int?
    
    let nameCalls = ["老爸", "老媽", "兒子", "女兒",
                     "爹地", "媽咪", "哥哥", "姊姊",
                     "爸爸", "媽媽", "弟弟", "妹妹",
                     "男友", "女友", "室友", "情人",
                     "自訂"]
    
    @IBAction func createNewHome(_ sender: Any) {
        
        if selectedNameIndex == nil {
            
            showShouldSelect()
        
        } else {
            
            if selectedNameIndex == nameCalls.count - 1 && customUserName.text == "" {
                
                showAlertOfNilText()
                
            } else {
             
                if createHomeName.text == "" {
                    
                    showAlertOfNilText()
                    
                } else {
                    
                    guard let key = createPassword.text else { return }
                    
                    UserDefaults.standard.set(key, forKey: "userKey")
        
                    // TODO: 將資料存到 dataBase
                    // 要把 textField、cell 中的文字一起存
                    let rootVC = UIStoryboard.main.instantiateInitialViewController()!
                    
                    self.show(rootVC, sender: nil)
                }
            }
        }
        
    }
    
    @IBAction func findHome(_ sender: Any) {
        
        if userPassword.text == "" || userID.text == "" {
            
            showAlertOfNilText()
            
        } else {
            
            // TODO: 找 dataBase 的資料
            // 有這個使用者才存 userDefault !!
            
            guard let key = userPassword.text else { return }
            
            UserDefaults.standard.set(key, forKey: "userKey")
            
            let rootVC = UIStoryboard.main.instantiateInitialViewController()!
            
            self.show(rootVC, sender: nil)
            
        }

    }
    
}

extension AuthViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nameCalls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = nameCallSelection.dequeueReusableCell(
            withReuseIdentifier: "NameCallCollectionViewCell", for: indexPath)
        
        guard let nameCallItem = item as? NameCallCollectionViewCell else { return UICollectionViewCell() }
        
        nameCallItem.backgroundColor = UIColor.buttonUnSelected
        
        nameCallItem.nameCall.text = nameCalls[indexPath.row]
        
        return nameCallItem
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let nameCallItem = nameCallSelection.cellForItem(at: indexPath)
            
              as? NameCallCollectionViewCell else { return }
        
        nameCallItem.backgroundColor = UIColor.buttonSelected
        
        nameCallItem.nameCall.textColor = UIColor.noticeGray
        
        if indexPath.row == nameCalls.count - 1 {
            
            customUserName.isHidden = false
            
            // TODO: 變數存 textField 的文字
            
        }
        
        // TODO: 將 cell 中 label 的文字存到一個變數中
        //
        selectedNameIndex = indexPath.row
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let nameCallItem = nameCallSelection.cellForItem(at: indexPath)
            
            as? NameCallCollectionViewCell else { return }
        
        nameCallItem.backgroundColor = UIColor.buttonUnSelected
        
        nameCallItem.nameCall.textColor = .white
        
        if indexPath.row == nameCalls.count - 1 {
            
            customUserName.isHidden = true
            
        }
    }
    
}
