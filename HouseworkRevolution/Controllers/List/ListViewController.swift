//
//  ListViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/3.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var magicLampView: UIView!
    
    @IBOutlet weak var lampViewWishLabel: UILabel!
    
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var emptyMissionView: UIView!
    
    @IBOutlet weak var showNoMissionLabel: UILabel!
    
    @IBOutlet weak var userHelpBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpSubViews()
        
        setUpCollectionView()
        
        notificationRegisterAndAuth()
        
        FirebaseManager.shared.delegate = self
        
        FirebaseNotificationHelper.shared.getUserName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        animateTheNoticeLabel()
        
        ProgressHUD.show()
        
        FirebaseManager.shared.checkToday(completion: {
            
            FirebaseManager.shared.getMissionListToday()
        })
        
        FirebaseNotificationHelper.shared.findFamilyMemberTokens()
    }
    
    @IBOutlet weak var dailyMissionCollectionView: UICollectionView! {
        
        didSet {
            
            dailyMissionCollectionView.delegate = self
            
            dailyMissionCollectionView.dataSource = self
            
            dailyMissionCollectionView.dragDelegate = self

            dailyMissionCollectionView.dragInteractionEnabled = true

            dailyMissionCollectionView.dropDelegate = self
        }
    }
    
    @IBOutlet weak var dailyMissionFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    var missionUndoToday = [Mission]() {
        
        didSet {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.dailyMissionCollectionView.reloadData()
                
                self?.showMissionEmpty()
            }
        }
    }
    
    var missionDoneToday = [Mission]() {
        
        didSet {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.dailyMissionCollectionView.reloadData()
                
                self?.showMissionEmpty()
            }
        }
    }
    
    func showMissionEmpty() {
        
        dailyMissionCollectionView.endPullToRefresh(dailyMissionCollectionView)
        
        if missionUndoToday.count == 0 && missionDoneToday.count == 0 {
            
            emptyMissionView.isHidden = false
            
            ProgressHUD.dismiss()
            
        } else {
            
            emptyMissionView.isHidden = true
            
            ProgressHUD.dismiss()
        }
    }
    
    func setUpSubViews() {
        
        magicLampView.alpha = 0.0
        
        skipBtn.alpha = 0.0
        
        emptyMissionView.isHidden = true
        
        let today = DayManager.shared.changeWeekdayIntoCH(weekday: DayManager.shared.weekday)
        
        showNoMissionLabel.text = "尚未設定今天（\(today)）的家事"
    }
    
    private let spacing: CGFloat = 16.0
    
    func setUpCollectionView() {
        
        dailyMissionCollectionView.register(
                UINib(nibName: String(describing: DailyMissionHeaderView.self), bundle: nil),
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: DailyMissionHeaderView.self))
        
        dailyMissionFlowLayout.sectionInset = UIEdgeInsets(top: spacing,
                                                           left: spacing,
                                                           bottom: spacing,
                                                           right: spacing)
        
        dailyMissionFlowLayout.minimumLineSpacing = spacing
        
        dailyMissionFlowLayout.minimumInteritemSpacing = spacing
        
        dailyMissionFlowLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 40.0)
        
        dailyMissionCollectionView.addPullToRefresh(dailyMissionCollectionView) {
            
            FirebaseManager.shared.getMissionListToday()
        }
    }

    func notificationRegisterAndAuth() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        appDelegate.showAuthRequest(application: UIApplication.shared)
        
        FirebaseNotificationHelper.shared.updateFirestorePushTokenIfNeeded()
    }
    
    func animateTheNoticeLabel() {
        
        noticeLabel.alpha = 1
        
        userHelpBtn.alpha = 0
        
        UIView.animate(withDuration: 6.0, animations: { [weak self] in
            
            // swiftlint:disable multiple_closures_with_trailing_closure
            self?.noticeLabel.alpha = 0 }) { [weak self] (isCompleted) in
            
                if isCompleted {
                
                    self?.userHelpBtn.alpha = 0.7
                }
            }
    }
    
    var itemHeight: CGFloat = 0.0

    let showAnimate = UIViewPropertyAnimator(duration: 0.8, curve: .linear)
    
    let viewDisappearAnimate = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    // MARK: - 實現願望
    func magicLampViewShow() {
        
        var wishes = [String]()
        
        FirebaseUserHelper.shared.readWishesOf(
            user: StorageManager.userInfo.userID) { [weak self] (wishArr) in
            
                wishes = wishArr
                
                if wishArr.count > 0 {
                    
                    guard let completeWish: String = wishes.randomElement() else { return }
                    
                    self?.lampViewWishLabel.text = completeWish
                    
                    FirebaseUserHelper.shared.removeWishOf(content: completeWish,
                                                           user: StorageManager.userInfo.userID)
                    
                    self?.skipBtn.alpha = 1.0
                    
                    self?.showAnimate.addAnimations { [weak self] in
                        
                        self?.magicLampView.alpha = 1.0
                    }
                    
                    self?.viewDisappearAnimate.addAnimations { [weak self] in
                        
                        self?.magicLampView.alpha = 0.0
                    }
                    
                    self?.showAnimate.addCompletion { [weak self] _ in
                        
                        self?.viewDisappearAnimate.startAnimation(afterDelay: 5.0)
                    }
                    
                    self?.viewDisappearAnimate.addCompletion({ [weak self] (_) in
                        
                        self?.skipBtn.alpha = 0.0
                        
                    })
                    
                    self?.viewDisappearAnimate.isInterruptible = true
                    
                    self?.showAnimate.isInterruptible = true
                    
                    self?.showAnimate.startAnimation()
                    
                } else {
                    
                    self?.directToWishPage(message: "神燈裡沒有願望了！")
                }
                
            }
        }
    
    @IBAction func skipAnimateOfMagicView(_ sender: Any) {
        
        showAnimate.stopAnimation(true)
        
        viewDisappearAnimate.stopAnimation(true)
        
        magicLampView.alpha = 0.0
        
        skipBtn.alpha = 0.0
    }
    
    func directToWishPage(message: String) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "許願去", style: .default, handler: {[weak self] _ in
            
            self?.directToViewAt(index: 2)
        })
        
        action.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(action)
        
        let cancelAction = UIAlertAction(title: "下次再許", style: .cancel, handler: nil)
        
        cancelAction.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goToAddMission(_ sender: Any) {
        
        directToViewAt(index: 1)
    }
    
    @IBAction func showUserHelp(_ sender: Any) {
        
        let userHelpViewController = UIStoryboard.list.instantiateViewController(
            withIdentifier: String(describing: UserHelpViewController.self))
        
        guard let userHelpView = userHelpViewController as? UserHelpViewController else { return }
        
        userHelpView.modalPresentationStyle = .overFullScreen
        
        present(userHelpView, animated: false, completion: nil)
    }
    
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 4
        
        let spacingBetweenCells: CGFloat = 16
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        let width = (fullScreenSize.width - totalSpacing) / numberOfItemsPerRow
            
        itemHeight = width
            
        return CGSize(width: width, height: width)
    }
    
}

extension ListViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView
    ) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                    withReuseIdentifier: String(describing: DailyMissionHeaderView.self),
                                    for: indexPath)
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            guard let headerView = header
                as? DailyMissionHeaderView else { return UICollectionReusableView() }
            
            if indexPath.section == 0 {
                
                headerView.sectionTitle.text = "還有哪些家事任務呢？"
            } else {
                
                headerView.sectionTitle.text = "完成了！"
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        
        switch section {
            
        case 0:
            
            return missionUndoToday.count
            
        case 1:
            
            return missionDoneToday.count
            
        default:
            
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let item = dailyMissionCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DailyMissionCollectionViewCell.self), for: indexPath)
        
        guard let missionItem = item
            as? DailyMissionCollectionViewCell else { return UICollectionViewCell() }
        
        missionItem.layer.cornerRadius = itemHeight / 2
        
        switch  indexPath.section {
            
        case 0:
            
            missionItem.layout(background: UIColor.cellGreen,
                               mission: missionUndoToday[indexPath.row].title)
            
        case 1:
            
            missionItem.layout(background: UIColor.lightCellGreen,
                               mission: missionDoneToday[indexPath.row].title)
            
        default:
            
            break
        }
        
        return missionItem
    }
    
}

extension ListViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath
    ) -> [UIDragItem] {
        
        switch  indexPath.section {
        
        case 0:
            
            let sourceItem = missionUndoToday[indexPath.row]
            
            let provider = NSItemProvider(object: MissionItem(value: sourceItem.tiredValue,
                                                              content: sourceItem.title))
            
            let dragItem = UIDragItem(itemProvider: provider)
            
            dragItem.localObject = sourceItem
            
            return [dragItem]
            
        case 1:
            
            return[]
            
        default:
            
            return[]
        }
    }
    
}

extension ListViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag {
            
            return UICollectionViewDropProposal(operation: .move,
                                                intent: .insertIntoDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator,
                      destinationIndexPath: IndexPath,
                      collectionView: UICollectionView) {
        
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {
    
            item.dragItem.itemProvider.loadObject(ofClass: MissionItem.self
            ) { [weak self] (mission, error) in
                
                DispatchQueue.main.async {

                    guard let missionDropped = mission as? MissionItem else { return }
                    
                    let missionDone = Mission(title: missionDropped.content,
                                              tiredValue: missionDropped.tiredValue)
                
                    collectionView.performBatchUpdates({
                        
                        self?.missionUndoToday.remove(at: sourceIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        
                        self?.missionDoneToday.insert(missionDone, at: destinationIndexPath.item)
                        collectionView.insertItems(at: [destinationIndexPath])
                        
                    }, completion: nil)
                    
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    
                    FirebaseManager.shared.updateMissionStatus(title: missionDone.title,
                                                               tiredValue: missionDone.tiredValue)
                    
                    if missionDropped.tiredValue > 5 {
                        
                        self?.magicLampViewShow()
                        
                        FirebaseNotificationHelper.shared.sendNotificationToFamilies(
                            title: "\(FirebaseNotificationHelper.userName)完成「\(missionDone.title)」並實現了一個願望",
                            body: "起身動一動，完成可以實現願望的家事項目吧～")
                        
                    } else {
                        
                        FirebaseNotificationHelper.shared.sendNotificationToFamilies(
                        title: "\(FirebaseNotificationHelper.userName)完成了家事「\(missionDone.title)」",
                        body: "快跟上他的腳步，來做家事吧！")
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        
        let defaultDestination = IndexPath(item: 0, section: 1)
        
        if coordinator.proposal.operation == .move {

            guard let destination = coordinator.destinationIndexPath else {
                
                reorderItems(coordinator: coordinator,
                             destinationIndexPath: defaultDestination,
                             collectionView: collectionView)
                    
                    return
                }
                
                switch destination.section {
                    
                case 0:
                    
                    return
                    
                case 1:
                    
                    reorderItems(coordinator: coordinator,
                                 destinationIndexPath: destination,
                                 collectionView: collectionView)
                default:
                    
                    return
                }
            }
    }

}

extension ListViewController: FirebaseManagerDelegate {
    
    func getUndoListToday(_ manager: FirebaseManager, didGetUndo: [Mission]) {
        
        missionUndoToday = didGetUndo
    }
    
    func getDoneListToday(_ manager: FirebaseManager, didGetDone: [Mission]) {
        
        missionDoneToday = didGetDone
    }

}
