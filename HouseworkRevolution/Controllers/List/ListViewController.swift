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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("load list")
        
        fullScreenSize = UIScreen.main.bounds.size
        
        magicLampView.alpha = 0.0
        skipBtn.alpha = 0.0
        
        setUpCollectionView()
        
        FirebaseManager.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("appear list")
        animateTheNoticeLabel()
        
        FirebaseManager.shared.checkToday(family: StorageManager.userInfo.familyID) {
            
            FirebaseManager.shared.getMissionListToday(family: StorageManager.userInfo.familyID)
        }
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
    
    var fullScreenSize: CGSize?
    
    private let spacing: CGFloat = 16.0
    
    var missionUndoToday = [Mission]()
    
    var missionDoneToday = [Mission]()
    
    var missionBeDropped = MissionItem(value: 0, content: "")
    
    let showAnimate = UIViewPropertyAnimator(duration: 0.8, curve: .linear)
    
    let viewDisappearAnimate = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    
    func setUpCollectionView() {
        
        dailyMissionCollectionView.register(
                UINib(nibName: String(describing: DailyMissionHeaderView.self), bundle: nil),
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: DailyMissionHeaderView.self))
        
        dailyMissionFlowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        dailyMissionFlowLayout.minimumLineSpacing = spacing
        
        dailyMissionFlowLayout.minimumInteritemSpacing = spacing
        
        guard let screenWidth = fullScreenSize?.width else { return }
        
        dailyMissionFlowLayout.headerReferenceSize = CGSize(width: screenWidth, height: 40.0)
        
    }
    
    var itemHeight: CGFloat = 0.0
    
    func animateTheNoticeLabel() {
        
        noticeLabel.alpha = 1
        
        UIView.animate(withDuration: 5.0) { [weak self] in
            
            self?.noticeLabel.alpha = 0
        }
    }
    
    // TODO: 判斷疲勞值並秀 view
    func magicLampViewShow() {
        
        var wishes = [String]()
        
        FirebaseUserHelper.shared.readWishesOf(user: StorageManager.userInfo.userID) {
            
            [weak self] (wishArr) in
            
            wishes = wishArr
            
            guard let completeWish: String = wishes.randomElement() else { return }
            
            self?.lampViewWishLabel.text = completeWish
            
            FirebaseUserHelper.shared.removeWishOf(content: completeWish, user: StorageManager.userInfo.userID)
            
        }
        
        print("============magic!!")
        
        skipBtn.alpha = 1.0
        
        showAnimate.addAnimations { [weak self] in

            self?.magicLampView.alpha = 1.0
        }
        
        viewDisappearAnimate.addAnimations { [weak self] in
            
            self?.magicLampView.alpha = 0.0
        }
        
        showAnimate.addCompletion { [weak self] _ in
            
            self?.viewDisappearAnimate.startAnimation(afterDelay: 3.0)
        }
        
        viewDisappearAnimate.addCompletion({ [weak self] (_) in
            
            self?.skipBtn.alpha = 0.0
        })
        
        viewDisappearAnimate.isInterruptible = true
        
        showAnimate.isInterruptible = true
        
        showAnimate.startAnimation()
    }
    
    @IBAction func skipAnimateOfMagicView(_ sender: Any) {
        
        print("skip!!!!!!!!!!!!!!!!!!!!!")
        
        showAnimate.stopAnimation(true)
        
        viewDisappearAnimate.stopAnimation(true)
        
        magicLampView.alpha = 0.0
        
        skipBtn.alpha = 0.0
    
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
            
            guard let headerView = header as? DailyMissionHeaderView else { return UICollectionReusableView() }
            
            if indexPath.section == 0 {
                
                headerView.sectionTitle.text = "還有哪些家事任務呢？"
                
            } else {
                
                headerView.sectionTitle.text = "完成了！"
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = dailyMissionCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DailyMissionCollectionViewCell.self), for: indexPath)
        
        guard let missionItem = item as? DailyMissionCollectionViewCell else { return UICollectionViewCell() }
        
        missionItem.layer.cornerRadius = itemHeight / 2
        
        switch  indexPath.section {
            
        case 0:
            
            missionItem.backgroundColor = UIColor.cellGreen
            missionItem.dailyMissionLabel.text = missionUndoToday[indexPath.row].title
            missionItem.missionChargerLabel.text = ""
            
        case 1:
            
            missionItem.backgroundColor = UIColor.lightCellGreen
            missionItem.dailyMissionLabel.text = missionDoneToday[indexPath.row].title
            missionItem.missionChargerLabel.text = ""
            
        default:
            break
        }
        
        return missionItem
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
        
        if let screenWidth = fullScreenSize?.width {
            
            let width = (screenWidth - totalSpacing) / numberOfItemsPerRow
            
            itemHeight = width
            
            return CGSize(width: width, height: width)
            
        } else {
            
            return CGSize(width: 0, height: 0)
        }
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
            
            return[] // 不可 drag
            
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
            
            return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
            
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator,
                      destinationIndexPath: IndexPath,
                      collectionView: UICollectionView) {
        
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {
    
            item.dragItem.itemProvider.loadObject(ofClass: MissionItem.self) { [weak self] (mission, error) in
                
                DispatchQueue.main.async {

                    guard let missionDropped = mission as? MissionItem else { return }
                    
                    let missionDone = Mission(title: missionDropped.content, tiredValue: missionDropped.tiredValue)
                
                    collectionView.performBatchUpdates({
                        
                        self?.missionUndoToday.remove(at: sourceIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        
                        self?.missionDoneToday.insert(missionDone, at: destinationIndexPath.item)
                        collectionView.insertItems(at: [destinationIndexPath])
                        
                        }, completion: nil)
                    
                        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    
                    FirebaseManager.shared.updateMissionStatus(title: missionDone.title, tiredValue: missionDone.tiredValue, family: StorageManager.userInfo.familyID)
                    
                    print("==== mission complete ====")
                    
                    print(missionDone)
                    
                        if missionDropped.tiredValue > 5 {
                        
                            self?.magicLampViewShow()
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
        
        DispatchQueue.main.async { [weak self] in
            
           self?.dailyMissionCollectionView.reloadData()
            
            print("UndoToday: \(self?.missionUndoToday)")
        }
        
    }
    
    func getDoneListToday(_ manager: FirebaseManager, didGetDone: [Mission]) {
        
        missionDoneToday = didGetDone
        
        DispatchQueue.main.async { [weak self] in
            
            self?.dailyMissionCollectionView.reloadData()
            
            print("DoneToday: \(self?.missionDoneToday)")
        }
        
    }

}
