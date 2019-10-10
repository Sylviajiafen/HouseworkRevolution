//
//  InvitationController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/10/8.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class InvitationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseUserHelper.shared.showFamilyInvitation { [weak self] (invitingList) in
            
            ProgressHUD.dismiss()
            self?.invitingList = invitingList
        }
    }
    
    var invitingList = [InvitingFamily]()
    
    weak var delegate: InvitingFamilyTableViewCellDelegate?
}

extension InvitationController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView
    ) -> Int {
                   
        return 1
    }
           
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int
    ) -> CGFloat {
                   
        return 35.0
    }
           
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int
    ) -> UIView? {
            
      guard let header = tableView.dequeueReusableHeaderFooterView(
                       withIdentifier: String(describing: InvitingFamilySectionHeaderView.self))
                       as? InvitingFamilySectionHeaderView else { return nil }
                   
        return header
    }
           
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int
    ) -> CGFloat {
        
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return invitingList.count
    }
           
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                   
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: InvitingFamilyTableViewCell.self), for: indexPath)
                   
        guard let invitingListCell = cell as? InvitingFamilyTableViewCell else { return UITableViewCell() }
                   
        let invitingPerson = invitingList[indexPath.row].from
                   
        invitingListCell.invitingPersonLabel.text = "的「\(invitingPerson)」邀請您加入家庭"
                   
        invitingListCell.invitingFamilyName.text = invitingList[indexPath.row].familyName
                   
        invitingListCell.delegate = self.delegate
                   
        return invitingListCell
    }
}
