//
//  FamilyViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class FamilyViewController: UIViewController {

    @IBOutlet weak var invitingFamilyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        invitingFamilyTableView.delegate = self
        invitingFamilyTableView.dataSource = self
        
        // TODO: 抓 invitingFamily 資料
        invitingFamilyList = [InvitingFamilyList(family: "好狗窩", from: "媽咪"),
                            InvitingFamilyList(family: "壞狗窩", from: "爸比")]
    }

    var invitingFamilyList = [InvitingFamilyList(family: "", from: "")]
}

extension FamilyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
            
        case invitingFamilyTableView:
            return invitingFamilyList.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case invitingFamilyTableView:
            
            let cell = invitingFamilyTableView.dequeueReusableCell(
                withIdentifier: String(describing: InvitingFamilyTableViewCell.self), for: indexPath)
            
            guard let invitingListCell = cell as? InvitingFamilyTableViewCell else { return UITableViewCell() }
            
            let invitingPerson = invitingFamilyList[indexPath.row].from
            
            invitingListCell.invitingPersonLabel.text = "「\(invitingPerson)」邀請您加入"
            
            invitingListCell.invitingFamilyName.text = invitingFamilyList[indexPath.row].family
            
            return invitingListCell
            
        default:
            return UITableViewCell()
        }
    }
    
}
