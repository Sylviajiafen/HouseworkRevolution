//
//  SearchUserViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController {

    @IBOutlet weak var userIdSearchBar: UISearchBar!
    @IBOutlet weak var showResultTableView: UITableView!
    @IBOutlet weak var opacityDarkView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userIdSearchBar.delegate = self
        showResultTableView.dataSource = self
        
        print("Inviter: User => \(inviterUserName), Family => \(inviterFamilyName)")
        
        FirebaseUserHelper.shared.getAllUser { [weak self] (allUsers) in
            
            self?.userData = allUsers
            
            self?.updateResult()
        }
        
        addGestureToDarkView()
    }
    
    @IBAction func closeView(_ sender: Any) {
        
        shouldShowSearchResult = false
        self.dismiss(animated: true, completion: nil)
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
    
    func addGestureToDarkView() {
        
        let touchToDismiss = UITapGestureRecognizer(target: self, action: #selector(tapTodismiss))
        
        opacityDarkView.addGestureRecognizer(touchToDismiss)
    }
    
    @objc func tapTodismiss() {
        
        print("tab to dismiss!!")
        shouldShowSearchResult = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchUserViewController: UITableViewDataSource,
                                    SearchUserTableViewCellDelegate,
                                    UISearchBarDelegate {
    
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
            
            searchingCell.searchingMemberName.text = filteredData[indexPath.row].name
            searchingCell.searchingMemberId.text = filteredData[indexPath.row].id
            
            return searchingCell
            
        } else {
            
            let cell = showResultTableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowDefaultTableViewCell.self), for: indexPath)
                
            guard let showDefaultCell = cell as? ShowDefaultTableViewCell else { return UITableViewCell() }
                
            showDefaultCell.defaultLabel.text = "找找家人在哪裡～"
            
            return showDefaultCell
        }
    }
    
    // MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        updateResult()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        updateResult()
        userIdSearchBar.resignFirstResponder()
    }
    
    func updateResult() {
    
        guard let searchingString = userIdSearchBar.text else { return }
        
        if searchingString == "" {
            
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
                                                   from: StorageManager.userInfo.familyID,
                                                   familyName: inviterFamilyName,
                                                   inviter: inviterUserName,
                invitorCompletion: { [weak self] (result) in
                    
                    switch result {
                        
                    case .success(let message):
                        
                        self?.showAlertOf(message: message)
                        
                    case .failed(let err):
                        
                        self?.showAlertOf(message: err.rawValue)
                    }
                                                    
            })
        }
        
        userIdSearchBar.text = ""
        
        shouldShowSearchResult = false
    }
    
}
