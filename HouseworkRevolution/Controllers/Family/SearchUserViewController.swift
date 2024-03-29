//
//  SearchUserViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController {

    @IBOutlet weak var userIdSearchTF: UITextField!
    
    @IBOutlet weak var showResultTableView: UITableView!
    
    @IBOutlet weak var opacityDarkView: UIView!
    
    @IBOutlet weak var scannerImage: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        userIdSearchTF.delegate = self
        
        showResultTableView.dataSource = self
        
        FirebaseUserHelper.shared.getAllUser { [weak self] (allUsers) in
            
            self?.userData = allUsers
            
            self?.updateResult()
        }
        
        setUpSearchTF()
        
        setUpScanner()
        
        addTapToDismissGesture(on: opacityDarkView)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        FirebaseUserHelper.allUserListener?.remove()
        
        FirebaseUserHelper.allUserListener = nil
    }
    
    @IBAction func closeView(_ sender: Any) {
        
        shouldShowSearchResult = false
        
        self.dismiss(animated: false, completion: nil)
    }
    
    var shouldShowSearchResult: Bool = false {
        
        didSet {
            
            showResultTableView.reloadData()
        }
    }
    
    var inviterUserName: String = ""
    
    var inviterFamilyName: String = ""
    
    var userData = [MemberData]()
    
    var filteredData = [MemberData]() {
        
        didSet {
            
            showResultTableView.reloadData()
        }
    }
    
    var leftImageView = UIImageView()
    
    func setUpSearchTF() {
        
        let leftImage = UIImage.asset(.searchUser)
        
        leftImageView.image = leftImage
        
        leftImageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        
        userIdSearchTF.addSubview(leftImageView)
        
        userIdSearchTF.leftView = paddingView
    
        userIdSearchTF.leftViewMode = .always
        
        userIdSearchTF.addTarget(self, action: #selector(searchRealtimeUpdate),
                                 for: .editingChanged)
    }
    
    @objc func searchRealtimeUpdate() {
        
        updateResult()
    }

    func setUpScanner() {
        
        scannerImage.isUserInteractionEnabled = true
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(showScannerPage))
        
        scannerImage.addGestureRecognizer(touch)
    }
    
    @objc func showScannerPage() {
        
        let scannerViewController = UIStoryboard.family.instantiateViewController(
                   withIdentifier: String(describing: ScannerViewController.self))
           
        guard let targetView = scannerViewController as? ScannerViewController else { return }
        
        targetView.delegate = self
               
        targetView.modalPresentationStyle = .fullScreen
           
        present(targetView, animated: false, completion: nil)
               
        userIdSearchTF.clearText()
               
        updateResult()
    }
   
    @objc override func tapToDismiss() {
        
        shouldShowSearchResult = false
        
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension SearchUserViewController: UITableViewDataSource,
                                    SearchUserTableViewCellDelegate,
                                    UITextFieldDelegate {
    
    // MARK: Set TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        
        if shouldShowSearchResult {
            
            return filteredData.count
            
        } else {
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        if shouldShowSearchResult {
            
            let cell = showResultTableView.dequeueReusableCell(
                withIdentifier: String(describing: SearchUserTableViewCell.self), for: indexPath)
            
            guard let searchingCell = cell as? SearchUserTableViewCell else { return UITableViewCell() }
            
            searchingCell.delegate = self
            
            searchingCell.layout(by: filteredData[indexPath.row])
            
            return searchingCell
            
        } else {
            
            let cell = showResultTableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowDefaultTableViewCell.self), for: indexPath)
                
            guard let showDefaultCell = cell as? ShowDefaultTableViewCell else { return UITableViewCell() }
                
            showDefaultCell.defaultLabel.text = "找找家人在哪裡～"
            
            return showDefaultCell
        }
    }
    
    // MARK: Search
    func updateResult() {

        guard let searchingString = userIdSearchTF.text else { return }

        if searchingString == "" || searchingString.contains(" ") {

            shouldShowSearchResult = false

            return

        } else {

            shouldShowSearchResult = true

            filteredData = userData.filter({ (data) -> Bool in

                return data.id.contains(searchingString)

            })
        }
    }
    
    // MARK: Add Member
    func addMember(_ cell: SearchUserTableViewCell) {
        
        guard let index = showResultTableView.indexPath(for: cell) else { return }
        
        if filteredData[index.row].id == StorageManager.userInfo.userID {
            
            showAlertOf(message: "不小心邀請到自己了啦")
            
        } else {
            
            FirebaseUserHelper.shared.inviteMember(id: filteredData[index.row].id,
                                                   name: filteredData[index.row].name,
                                                   from: inviterFamilyName,
                                                   inviter: inviterUserName,
                inviteCompletion: { [weak self] (result) in
                    
                    switch result {
                        
                    case .success(let message):
                        
                        self?.showAlertOf(message: message)
                        
                    case .failed(let err):
                        
                        self?.showAlertOf(message: err.rawValue)
                    }
            })
        }
        
        userIdSearchTF.clearText()
        
        shouldShowSearchResult = false
    }
    
    // MARK: TFDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        updateResult()
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

extension SearchUserViewController: ScannerViewControllerDelegate {
    
    func inputDetectedUser(id: String) {
        
        userIdSearchTF.text = id
        
        updateResult()
    }
    
}
