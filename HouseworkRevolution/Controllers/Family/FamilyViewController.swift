//
//  FamilyViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/6.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class FamilyViewController: TextCountLimitBaseViewController {
    
    @IBOutlet weak var familyMemberTableView: UITableView!
    
    @IBOutlet weak var invitingFamilyTableView: UITableView!
    
    @IBOutlet weak var userCallLabel: UILabel!
    
    @IBOutlet weak var userIDBtn: UIButton!
    
    @IBOutlet weak var familyNameLabel: UILabel!
    
    @IBOutlet weak var dropOutView: UIView!
    
    @IBOutlet weak var informationIcon: UIImageView!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override var textLimitCount: Int { return 6 }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        invitingFamilyTableView.delegate = self
        
        invitingFamilyTableView.dataSource = self
        
        userIDBtn.setTitle(StorageManager.userInfo.userID, for: .normal)
        
        userIDBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        isOriginOrNot()
        
        setInformation()
        
        setQRCode()
        
        // MARK: regist header
        let headerXibOfMember = UINib(nibName: String(describing: FamilyMemberSectionHeader.self),
                                        bundle: nil)
        
        familyMemberTableView.register(headerXibOfMember,
                                       forHeaderFooterViewReuseIdentifier: String(describing: FamilyMemberSectionHeader.self))
        
        let headerXibOfInviting = UINib(nibName: String(describing: InvitingFamilySectionHeaderView.self),
                                        bundle: nil)
        
        invitingFamilyTableView.register(headerXibOfInviting,
                                         forHeaderFooterViewReuseIdentifier: String(describing: InvitingFamilySectionHeaderView.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {

        getHomeData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        removeListeners()
    }
    
    func setInformation() {
        
        informationIcon.isUserInteractionEnabled = true
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapOnInfo))
        
        informationIcon.addGestureRecognizer(touch)
    }
    
    @objc func tapOnInfo() {
        
        showAlertOf(title: "點擊下方 ID 即可複製",
                    message: "請妥善保存，換手機、重載app時會用到唷！")
    }
    
    func setQRCode() {
        
        qrCodeImage.isUserInteractionEnabled = true
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(showQRCodePage))
        
        qrCodeImage.addGestureRecognizer(touch)
    }
    
    @objc func showQRCodePage() {
        
        let qrCodeViewController = UIStoryboard.family.instantiateViewController(
            withIdentifier: String(describing: QRCodeViewController.self))
        
        guard let targetView = qrCodeViewController as? QRCodeViewController else { return }
        
        targetView.modalPresentationStyle = .overFullScreen
        
        guard let userName = self.userCallLabel.text else { return }
        
        targetView.userName = userName
        
        present(targetView, animated: false, completion: nil)
    }
    
    @IBAction func copyUserID(_ sender: Any) {
        
        let board  = UIPasteboard.general
        
        board.string = StorageManager.userInfo.userID
        
        ProgressHUD.showＷith(text: "複製！")
    }
    
    @IBAction func editUserCall(_ sender: Any) {
        
        showEditableAlertView(of: userCallLabel,
                              title: "編輯稱呼",
                              message: "換個自己喜歡的稱呼吧")
        { (newName) in
            
            FirebaseUserHelper.shared.changeName(user: StorageManager.userInfo.userID,
                                                 to: newName,
                                                 currentFamily: StorageManager.userInfo.familyID)
            
            FirebaseNotificationHelper.shared.getUserName()
        }
    }
    
    @IBAction func editFamilyName(_ sender: Any) {
        
        showEditableAlertView(of: familyNameLabel,
                              title: "編輯家庭名稱",
                              message: "幫自己的家取個響亮的名字吧")
        { (newName) in
                                
            FirebaseUserHelper.shared.changeFamilyName(family: StorageManager.userInfo.familyID,
                                                       to: newName)
        }
    }
    
    func showEditableAlertView(of label: UILabel,
                               title: String,
                               message: String,
                               completion: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.textFields?[0].delegate = self
        
        let okAction = UIAlertAction(title: "更改", style: .default) { _ in
            
            guard alert.textFields?[0].text != "",
                let newName = alert.textFields?[0].text else { return }
            
            label.text = alert.textFields?[0].text
            
            completion(newName)
        }
        
        okAction.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        cancelAction.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dropOutFamily(_ sender: Any) {
        
        let alert = UIAlertController(title: "退出家庭",
                                      message: "如果選擇退出，將會回到註冊時的家庭，確定嗎？",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "確定", style: .default) { [weak self] _ in
            
            self?.removeListeners()
            
            FirebaseUserHelper.shared.dropOutFamily(familyID: StorageManager.userInfo.familyID,
                                                    user: StorageManager.userInfo.userID,
                getOriginFamily: { [weak self] (origin) in
                    
                    StorageManager.shared.updateFamily(familyID: origin,
                        completion: { [weak self] in
                            
                            self?.getHomeData()
                            
                            DispatchQueue.main.async {
                                
                                self?.isOriginOrNot()
                            }
                    })
            })
        }
        
        okAction.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        cancelAction.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    var familyMember: [MemberData] = [] {
        
        didSet {
            
            familyMemberTableView.reloadData()
        }
    }
    
    var invitedMemberList: [MemberData] = [] {
        
        didSet {
            
            familyMemberTableView.reloadData()
        }
    }
    
    var invitingFamilyList: [InvitingFamily] = [] {
        
        didSet {
            
            showInvitingOrNot()
            
            invitingFamilyTableView.reloadData()
        }
    }
    
    func showInvitingOrNot() {
        
        if invitingFamilyList.count == 0 {
            
            invitingFamilyTableView.isHidden = true
            
        } else {
            
            invitingFamilyTableView.isHidden = false
            
        }
    }
    
    func isOriginOrNot() {
        
        FirebaseUserHelper.shared.comparingFamily(
            user: StorageManager.userInfo.userID) { [weak self] (originFamily) in
            
            if originFamily == StorageManager.userInfo.familyID {
                
                self?.dropOutView.isHidden = true
                
            } else {
                
                self?.dropOutView.isHidden = false
                
            }
        }
    }
    
    func getHomeData() {
        
        FirebaseUserHelper.shared.getHomeDatasOf(user: StorageManager.userInfo.userID,
                                                 family: StorageManager.userInfo.familyID,
            userNameHandler: { [weak self] (userName) in
                                                    
                self?.userCallLabel.text = userName
                                                    
            }, familyNameHandler: { [weak self] (familyName) in
                
                self?.familyNameLabel.text = familyName
                
                ProgressHUD.dismiss()
        })
        
        FirebaseUserHelper.shared.getFamilyMembers(family: StorageManager.userInfo.familyID,
            handler: { [weak self] (memberData) in
                                                    
                self?.familyMember = memberData
                
                ProgressHUD.dismiss()
        })
        
        FirebaseUserHelper.shared.showInvites(family: StorageManager.userInfo.familyID,
                                              user: StorageManager.userInfo.userID,
            invitedMember: { [weak self] (invitedMembers) in
                                                
                self?.invitedMemberList = invitedMembers
                                                
            }, invitingFamily: { [weak self] (invitingFamilies) in
                
                self?.invitingFamilyList = invitingFamilies
                
                ProgressHUD.dismiss()
        })
    }
    
    private func removeListeners() {
        
        FirebaseUserHelper.currentListenerRegistration?.remove()
        
        FirebaseUserHelper.currentListenerRegistration = nil
        
        FirebaseUserHelper.currentMemberListener?.remove()
        
        FirebaseUserHelper.currentMemberListener = nil
        
        FirebaseUserHelper.currentInvitationListener?.remove()
        
        FirebaseUserHelper.currentInvitationListener = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? SearchUserViewController,
            let familyName = familyNameLabel.text,
            let userName = userCallLabel.text else { return }
        
        destination.inviterUserName = userName
        
        destination.inviterFamilyName = familyName
        
        destination.modalPresentationStyle = .overFullScreen
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
                header.sectionTitleLabel.text = "家庭成員"
                header.addCorner()
                
                return header
                
            case 1:
                
                header.sectionTitleLabel.text = "邀請中的家人"
                
                header.addCorner()
                
                header.sectionContentView.alpha = 1.0
                
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
            
            return 20.0
            
        } else {
            
            return 0.000001
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
                
                memberCell.cancelInvitationBtn.isHidden = true
                
                return memberCell
                
            case 1:
                
                memberCell.setLabelColor(background: UIColor.buttonUnSelected,
                                         textColor: .white,
                                         idTextColor: .lightGray,
                                         alpha: 0.6)
                
                memberCell.memberCall.text = invitedMemberList[indexPath.row].name
                
                memberCell.memberId.text = invitedMemberList[indexPath.row].id
                
                memberCell.cancelInvitationBtn.isHidden = false
                
                memberCell.delegate = self
                
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
            
            invitingListCell.delegate = self
            
            return invitingListCell
            
        default:
            
            return UITableViewCell()
        }
    }

}

extension FamilyViewController: InvitingFamilyTableViewCellDelegate {
    
    func acceptInvitation(_ cell: InvitingFamilyTableViewCell) {
        
        guard let index = invitingFamilyTableView.indexPath(for: cell),
              let myName = userCallLabel.text else { return }
        
        let inviterFamilyID = invitingFamilyList[index.row].familyID
        
        removeListeners()
        
        FirebaseUserHelper.shared.acceptInvitation(from: inviterFamilyID,
                                                   myID: StorageManager.userInfo.userID,
                                                   myName: myName)
        
        StorageManager.shared.updateFamily(familyID: inviterFamilyID,
                completion: { [weak self] in
                    
                    self?.getHomeData()

                    DispatchQueue.main.async {
    
                        self?.isOriginOrNot()
                    }
        })
    }
    
    func rejectInvitation(_ cell: InvitingFamilyTableViewCell) {
        
        guard let index = invitingFamilyTableView.indexPath(for: cell) else { return }
        
        let inviterFamilyID = invitingFamilyList[index.row].familyID
        
        FirebaseUserHelper.shared.rejectInvitation(from: inviterFamilyID, myID: StorageManager.userInfo.userID)
    }
    
}

extension FamilyViewController: FamilyMemberTableViewCellDelegate {
    
    func cancelInvitation(_ cell: FamilyMemberTableViewCell) {
        
        guard let index = familyMemberTableView.indexPath(for: cell) else { return }
        
        let invitedMemberID = invitedMemberList[index.row].id
        
        FirebaseUserHelper.shared.rejectInvitation(from: StorageManager.userInfo.familyID, myID: invitedMemberID)
    }
}
