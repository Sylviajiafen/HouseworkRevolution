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
            
            print("shouldShow的 didset")
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
                                    UISearchBarDelegate
                                    {
    
    // MARK : Set TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        print("========  reload numberOfRows")
        
        if shouldShowSearchResult {
            
            return filteredData.count
        } else {
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        if shouldShowSearchResult {
            
            print("========  reload Cell")
            
            let cell = showResultTableView.dequeueReusableCell(withIdentifier: String(describing: SearchUserTableViewCell.self),
                                                               for: indexPath)
            
            guard let searchingCell = cell as? SearchUserTableViewCell else { return UITableViewCell() }
            
            searchingCell.searchingMemberName.text = filteredData[indexPath.row].name
            searchingCell.searchingMemberId.text = filteredData[indexPath.row].memberId
            
            return searchingCell
            
        } else {
            
            return UITableViewCell()
        }
    }
    
    // Mark: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        shouldShowSearchResult = true

        guard let searchingString = userIdSearchBar.text else { return }

        filteredData = userData.filter({ (data) -> Bool in

            return data.memberId.contains(searchingString)
        })

    }
    
    // Mark: Search Controller
//    func configureSearchController() {
//
//        searchController = UISearchController(searchResultsController: self)
//        searchController?.searchResultsUpdater = self
//        searchController?.delegate = self
//    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//
//        print("=======update")
//
//        guard let searchingString = userIdSearchBar.text else { return }
//
//        filteredData = userData.filter({ (data) -> Bool in
//
//            return data.memberId.contains(searchingString)
//        })
//
//        showResultTableView.reloadData()
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//
//        print("==========begin")
//        shouldShowSearchResult = true
//        showResultTableView.reloadData()
//    }
//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        print("==========clicked")

//        if !shouldShowSearchResult {
//
//            shouldShowSearchResult = true
//            showResultTableView.reloadData()
//        }
//
//        userIdSearchBar.resignFirstResponder()
    }
}
