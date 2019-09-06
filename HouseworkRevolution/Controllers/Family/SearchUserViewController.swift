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
        // TODO: filter data
        
        filteredData = [Member(name: "兒子", memberId: "qFwZkG9baiRmKQSTtTEv")]
    }
    
    @IBAction func closeView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var userData = [Member]()
    
    var filteredData = [Member]()
}

extension SearchUserViewController: UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = showResultTableView.dequeueReusableCell(withIdentifier: String(describing: SearchUserTableViewCell.self),
                                                           for: indexPath)
        
        guard let searchingCell = cell as? SearchUserTableViewCell else { return UITableViewCell() }
        
        searchingCell.searchingMemberName.text = filteredData[indexPath.row].name
        searchingCell.searchingMemberId.text = filteredData[indexPath.row].memberId
        
        return searchingCell
    }
    
}
