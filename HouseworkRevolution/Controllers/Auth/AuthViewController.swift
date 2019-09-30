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
    
    @IBOutlet weak var pwdConfirmField: UITextField!
    
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
        
        createHomeName.delegate = self
        
        customUserName.delegate = self
        
        //
        
        createPassword.delegate = self
        
        pwdConfirmField.delegate = self
        
        userPassword.delegate = self
    }
    
    @IBAction func showUserSetting(_ sender: Any) {
        
        if createPassword.text == "" || pwdConfirmField.text == "" {
            
            showAlertOf(message: "欄位留白囉")
        
        } else if createPassword.text != pwdConfirmField.text {
            
            showAlertOf(message: "密碼不一致唷")
        
        } else {
        
            userSettingView.isHidden = false
            
        }
    }
    
    @IBAction func showSignIn(_ sender: Any) {
        
        signInView.isHidden = false
        
        signUpView.isHidden = true
        
        createPassword.text = ""
        
        pwdConfirmField.text = ""
    }
    
    @IBAction func showSignUp(_ sender: Any) {
        
        signInView.isHidden = true
        
        userID.text = ""
        
        userPassword.text = ""
        
        signUpView.isHidden = false
        
    }
    
    @IBAction func dissmissUserSetting(_ sender: Any) {
        
        userSettingView.isHidden = true
        
        createPassword.text = ""
        
        pwdConfirmField.text = ""
    }
    
    func showLogin(message: String) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "翻轉家事 Go!", style: .default, handler: { _ in
            
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            
            appdelegate?.window?.rootViewController = UIStoryboard.main.instantiateInitialViewController()!
            
        })
        
        action.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
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
            
            showAlertOf(message: "選擇一個稱呼吧")
        
        } else {
            
            if selectedNameIndex == nameCalls.count - 1 && customUserName.text == "" {
                
                showAlertOf(message: "欄位留白囉")
                
            } else {
             
                if createHomeName.text == "" {
                    
                    showAlertOf(message: "記得幫自己的家取個名唷")
                    
                } else {
                    
                    guard let pwd = createPassword.text,
                        let selectedIndex = selectedNameIndex,
                        let familyName = createHomeName.text else { return }
                    
                    let user = FamilyMember(password: pwd)
                    
                    let family = FamilyGroup(name: familyName)
                    
                    if selectedIndex == nameCalls.count - 1 {
                        
                        guard let userName = customUserName.text else { return }
                        
                        ProgressHUD.show()
                        
                        FirebaseUserHelper.shared.registAnIdWithEncrypt(user) { [weak self] (result) in
                            
                            switch result {
                                
                            case .success( _):
                                
                                FirebaseUserHelper.shared
                                    .registDoneWith(family, username: userName) { [weak self] (result) in
                                
                                        switch result {
                                            
                                        case .success(let message):
                                            
                                            StorageManager.shared.saveUserInfo(uid: FirebaseUserHelper.userID,
                                                                               familyRecognizer: FirebaseUserHelper.familyID)
                                            
                                            UserDefaults.standard.set(UserDefaultString.value.rawValue,
                                                                      forKey: UserDefaultString.key.rawValue)
                                            
                                            ProgressHUD.dismiss()
                                            
                                            self?.showLogin(message: message)
                                            
                                        case .failed(let err):
                                            
                                            self?.showAlertOf(message: "\(err)")
                                        }
                                }
                                
                            case .failed(let err):
                                
                                self?.showAlertOf(message: "\(err)")
                            }
                        }
                        
                    } else {
                        
                        ProgressHUD.show()
                        
                        FirebaseUserHelper.shared.registAnIdWithEncrypt(user) { [weak self] (result) in
                            
                            switch result {
                                
                            case .success( _):
                                
                                FirebaseUserHelper.shared
                                    .registDoneWith(family,
                                    username: self?.nameCalls[selectedIndex] ?? "(名稱)") { [weak self] (result) in
                                        
                                        switch result {
                                            
                                        case .success(let message):
                                            
                                            StorageManager.shared.saveUserInfo(uid: FirebaseUserHelper.userID,
                                                                           familyRecognizer: FirebaseUserHelper.familyID)
                                                                                    
                                            UserDefaults.standard.set(UserDefaultString.value.rawValue,
                                                                      forKey: UserDefaultString.key.rawValue)
                                                                                    
                                            ProgressHUD.dismiss()
                                                                                    
                                            self?.showLogin(message: message)
                                            
                                        case .failed(let err):
                                            
                                            self?.showAlertOf(message: "\(err)")
                                        }
                                }
                                
                            case .failed(let err):
                                
                                self?.showAlertOf(message: "\(err)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func findHome(_ sender: Any) {
        
        if userPassword.text == "" || userID.text == "" {
            
            showAlertOf(message: "欄位留白囉")
            
        } else {
            
            guard let loginId = userID.text, let loginPWD = userPassword.text else { return }
            
            ProgressHUD.show()
            
            FirebaseUserHelper.shared.loginWithDecrypt(id: loginId, password: loginPWD) { [weak self] (result) in
                
                switch result {
                    
                case .success(let messege):
                    
                    StorageManager.shared.saveUserInfo(uid: FirebaseUserHelper.userID,
                                                       familyRecognizer: FirebaseUserHelper.familyID)
                    
                    UserDefaults.standard.set(UserDefaultString.value.rawValue,
                                              forKey: UserDefaultString.key.rawValue)
                    
                    self?.showLogin(message: messege)
                    
                    ProgressHUD.dismiss()
                    
                case .failed(let err):
                    
                    self?.showAlertOf(message: err.rawValue)
                    
                    ProgressHUD.dismiss()
                }
            }
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
        
        selectedNameIndex = indexPath.row
        
        if indexPath.row == nameCalls.count - 1 {
            
            customUserName.isHidden = false
        }
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

extension AuthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if textField == customUserName || textField == createHomeName {
            
            let currentText = textField.text ?? ""
            
            guard let stringRange = Range(range, in: currentText) else { return false }

            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 6
        
        } else {
            
            let pattern = "[A-Za-z0-9]"
            
            let regex = NSRegularExpression(pattern)
            
            return regex.matches(string)
        }
    }
}
