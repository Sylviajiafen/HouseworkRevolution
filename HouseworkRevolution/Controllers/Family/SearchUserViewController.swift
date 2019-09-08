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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userIdSearchBar.delegate = self
        showResultTableView.dataSource = self
        
        // TODO: 抓所有 user (要加監聽)
        userData = [Member(name: "兒子", memberId: "qFwZkG9baiRmKQSTtTEv")]
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
    
    var userData = [Member]()
    
    var filteredData = [Member]() {
        
        didSet {
            
            showResultTableView.reloadData()
        }
    }
    
    var searchController: UISearchController?
}

extension SearchUserViewController: UITableViewDataSource,
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
            
            searchingCell.searchingMemberName.text = filteredData[indexPath.row].name
            searchingCell.searchingMemberId.text = filteredData[indexPath.row].memberId
            
            return searchingCell
            
        } else {
            
            let cell = showResultTableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowDefaultTableViewCell.self), for: indexPath)
                
            guard let showDefaultCell = cell as? ShowDefaultTableViewCell else { return UITableViewCell() }
                
            showDefaultCell.defaultLabel.text = "找找家人在哪裡～"
            
            return showDefaultCell
        }
    }
    
    // Mark: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        updateResult()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        updateResult()
        userIdSearchBar.resignFirstResponder()
    }
    
    func updateResult() {
        
        shouldShowSearchResult = true
        
        guard let searchingString = userIdSearchBar.text else { return }
        
        if searchingString == "" {
            
            shouldShowSearchResult = false
            
            return
            
        } else {
        
            filteredData = userData.filter({ (data) -> Bool in
            
            return data.memberId.contains(searchingString)
            })
        }
    }
}
