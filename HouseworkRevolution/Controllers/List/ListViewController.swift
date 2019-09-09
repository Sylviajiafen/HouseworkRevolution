//
//  ListViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/3.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    // TODO: 同步 dataBase
    // viewDidLoad?? 先判斷今天日期有沒有 dailyMission 了，沒有的話再今天星期幾，把今天這個星期的 mission 抓下來放進 dailyMission 中
    // dailyMission. missionDone + 當天日期 上傳至 dataBase ＝>  dailyMission 和 MissionDone 要連同當天日期一起存進 dataBase 裡(dailyMission 不是存在星期幾的那個資料庫中，而是另外再開)
    // 從 dataBase 抓取今天的 dailyMission
    
    // 找 LUKE 討論
    
    @IBOutlet weak var magicLampView: UIView!
    @IBOutlet weak var lampViewWishLabel: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullScreenSize = UIScreen.main.bounds.size
        
        magicLampView.alpha = 0.0
        skipBtn.alpha = 0.0
        
        setUpCollectionView()
        
        dailyMission = [
            ["charger": "1老媽", "mission": "1掃地"],
            ["charger": "2老爸", "mission": "2倒垃圾"],
            ["charger": "3兒子", "mission": "3洗碗"],
            ["charger": "4老媽", "mission": "4洗衣服"],
            ["charger": "5女兒", "mission": "5煮飯"],
            ["charger": "6老媽", "mission": "6晾衣服"]
        ]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        animateTheNoticeLabel()
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
    
    var dailyMission = [[String: String]]() // String or dictionary (key: Mission, value: Charger 或顛倒)
    
    var missionDone: [Mission] = []
    
    var missionBeDropped = Mission(charger: "", content: "")
    
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
            return dailyMission.count
            
        case 1:
            return missionDone.count
            
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
            missionItem.dailyMissionLabel.text = dailyMission[indexPath.row]["mission"]
//            missionItem.missionChargerLabel.text = dailyMission[indexPath.row]["charger"]
            missionItem.missionChargerLabel.text = ""
            
        case 1:
            
            missionItem.backgroundColor = UIColor.lightCellGreen
            missionItem.dailyMissionLabel.text = missionDone[indexPath.row].content
//            missionItem.missionChargerLabel.text = missionDone[indexPath.row].charger
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
            
            let sourceItem = dailyMission[indexPath.row]
            
            let provider = NSItemProvider(object: Mission(charger: sourceItem["charger"] ?? "",
                                                          content: sourceItem["mission"] ?? ""))
            
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
    
            item.dragItem.itemProvider.loadObject(ofClass: Mission.self) { [weak self] (mission, error) in
                
                DispatchQueue.main.async {

                    guard let missionDropped = mission as? Mission else { return }
                
                    collectionView.performBatchUpdates({
                        
                        self?.dailyMission.remove(at: sourceIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        
                        self?.missionDone.insert(missionDropped, at: destinationIndexPath.item)
                        collectionView.insertItems(at: [destinationIndexPath])
                        
                        }, completion: nil)
                    
                        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    
                    // TODO: indexPath 會變，所以要存一個疲勞值的 parameter，用此疲勞值去判斷
                        if sourceIndexPath == IndexPath(item: 2, section: 0) {
                        
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
    
    // TODO: 判斷任務內容疲勞度，是否秀神燈
    // func collectionView(UICollectionView, dropSessionDidEnd: UIDropSession)

}
