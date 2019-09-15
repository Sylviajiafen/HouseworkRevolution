//
//  FamilyViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class FamilyViewController: UIViewController {

    @IBOutlet weak var familyMemberTableView: UITableView!
    @IBOutlet weak var invitingFamilyTableView: UITableView!
    
    @IBOutlet weak var userCallLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        invitingFamilyTableView.delegate = self
        invitingFamilyTableView.dataSource = self
        
        // MARK: regist header
        let headerXibOfMember = UINib(nibName: String(describing: FamilyMemberSectionHeader.self),
                                        bundle: nil)
        
        familyMemberTableView.register(headerXibOfMember,
                                       forHeaderFooterViewReuseIdentifier: String(describing: FamilyMemberSectionHeader.self))
        
        let headerXibOfInviting = UINib(nibName: String(describing: InvitingFamilySectionHeaderView.self),
                                        bundle: nil)
        
        invitingFamilyTableView.register(headerXibOfInviting,
                                         forHeaderFooterViewReuseIdentifier: String(describing: InvitingFamilySectionHeaderView.self))
        
        // TODO: 抓 invitingFamily 資料 (寫在 function)
        // TODO: 判斷 invitingFamily.count == 0 時， tableView 隱藏 (寫在function 裡, parameter 一個為 tableView)
        // TODO: 放 pull refresh ：把 showInvitingOrNot(), tableView.reloadData 放在 completion 裡
        
       
        
//        invitingFamilyList = []

//        invitedMemberList = [Member(name: "老爸", memberId: "XQ8gMqFhCON6V97jP6Fl")]
        
        
    }
    
    @IBAction func editUserCall(_ sender: Any) {
        
        let alert = UIAlertController(title: "編輯稱呼", message: "換個自己喜歡的稱呼吧", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let okAction = UIAlertAction(title: "更改", style: .default) { [weak self] _ in
            
            guard alert.textFields?[0].text != "" else { return }
            
            self?.changedUserCall = alert.textFields?[0].text
                
            self?.userCallLabel.text = self?.changedUserCall
        }
        
        okAction.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        cancelAction.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    var changedUserCall: String? {
        
        didSet {
            
            // TODO: 更新 dataBase user 名稱
        }
    }
    
    var familyMember: [MemberData] = []
    
    var invitedMemberList: [MemberData] = []
    
    var invitingFamilyList: [InvitingFamily] = [] {
        
        didSet {
            
            showInvitingOrNot()
        }
    }
    
    func showInvitingOrNot() {
        
        if invitingFamilyList.count == 0 {
            
            invitingFamilyTableView.isHidden = true
        } else {
            
            invitingFamilyTableView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //TODO: 把 family Name, user Name 傳去 SearchVC
    }
}

extension FamilyViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Section Header
    func numberOfSections(in tableView: UITableView
    ) -> Int {
        
        switch tableView {
            
        case familyMemberTableView:
            
            if invitedMemberList.count > 0 {
                
                return 2
                
            } else {
                
                return 1
            }
            
        case invitingFamilyTableView:
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int
    ) -> CGFloat {
    
        switch tableView {
            
        case familyMemberTableView:
            return 30.0 
            
        case invitingFamilyTableView:
            return 35.0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int
    ) -> UIView? {
        
        switch tableView {
            
        case familyMemberTableView:
            
            guard let header = familyMemberTableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: FamilyMemberSectionHeader.self))
                as? FamilyMemberSectionHeader else { return nil }
            
            switch section {
                
            case 0:
                header.sectionTitleLabel.text = "成員"
                header.addCorner()
                return header
                
            case 1:
                header.sectionTitleLabel.text = "邀請中的成員"
                header.addCorner()
                header.sectionContentView.alpha = 0.6
                return header
                
            default:
                return nil
            }
            
        case invitingFamilyTableView:
            
            guard let header = invitingFamilyTableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: InvitingFamilySectionHeaderView.self))
                as? InvitingFamilySectionHeaderView else { return nil }
            
            return header
            
        default:
            return nil
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int
    ) -> CGFloat {
        
        if tableView == familyMemberTableView {
            
            return 10.0
        } else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int
    ) -> UIView? {
        
        if tableView == familyMemberTableView {
            
            let footer = UIView()
            
            footer.backgroundColor = UIColor.projectBackground
            
            return footer
        } else {
            
            return nil
        }
        
    }
    
    // MARK: TableView Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
            
        case familyMemberTableView:
            
            switch section {
                
            case 0:
                return familyMember.count
                
            case 1:
                return invitedMemberList.count
            
            default:
                return 0
            }
            
        case invitingFamilyTableView:
            return invitingFamilyList.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case familyMemberTableView:
            
            let cell = familyMemberTableView.dequeueReusableCell(
                withIdentifier: String(describing: FamilyMemberTableViewCell.self), for: indexPath)
            
            guard let memberCell = cell as? FamilyMemberTableViewCell else { return UITableViewCell() }
            
            switch indexPath.section {
                
            case 0:
                
                memberCell.setLabelColor(background: UIColor.buttonUnSelected,
                                         textColor: UIColor.noticeGray,
                                         idTextColor: .lightGray,
                                         alpha: 1.0)
                
                memberCell.memberCall.text = familyMember[indexPath.row].name
                memberCell.memberId.text = familyMember[indexPath.row].id
                
                return memberCell
                
            case 1:
                
                memberCell.setLabelColor(background: UIColor.buttonUnSelected,
                                         textColor: .white,
                                         idTextColor: .lightGray,
                                         alpha: 0.6)
                
                memberCell.memberCall.text = invitedMemberList[indexPath.row].name
                memberCell.memberId.text = invitedMemberList[indexPath.row].id
                
                return memberCell
                
            default:
                return UITableViewCell()
            }
            
        case invitingFamilyTableView:
            
            let cell = invitingFamilyTableView.dequeueReusableCell(
                withIdentifier: String(describing: InvitingFamilyTableViewCell.self), for: indexPath)
            
            guard let invitingListCell = cell as? InvitingFamilyTableViewCell else { return UITableViewCell() }
            
            let invitingPerson = invitingFamilyList[indexPath.row].from
            
            invitingListCell.invitingPersonLabel.text = "的「\(invitingPerson)」邀請您加入家庭"
            
            invitingListCell.invitingFamilyName.text = invitingFamilyList[indexPath.row].familyName
            
            return invitingListCell
            
        default:
            return UITableViewCell()
        }
    }
    
}
