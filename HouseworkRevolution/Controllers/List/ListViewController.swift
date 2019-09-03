//
//  ListViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/3.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        fullScreenSize = UIScreen.main.bounds.size
        
        setUpCollectionView()
        
        dailyMissionUnDone = ["掃地", "洗衣", "買菜", "掃廁所", "晾衣服"]
        
        missionCharger = ["老媽", "老媽", "妹妹", "老爸", "兒子"]
        
        dailyMissionDone = ["洗碗", "鏟貓砂"]
    }
    
    @IBOutlet weak var dailyMissionCollectionView: UICollectionView! {
        
        didSet {
            
            dailyMissionCollectionView.delegate = self
            
            dailyMissionCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var dailyMissionFlowLayout: UICollectionViewFlowLayout!
    
    var fullScreenSize: CGSize?
    
    private let spacing: CGFloat = 16.0
    
    // TODO: 抓 database , 參考舊專案 ProfileVc 的 section 寫法
    var dailyMissionUnDone = [String]() // String or dictionary (key: Mission, value: Charger 或顛倒)
    
    var dailyMissionDone = [String]()
    
    var missionCharger = [String]() // String or dictionary (key: Mission, value: Charger)
    
    func setUpCollectionView() {
        
        dailyMissionFlowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        dailyMissionFlowLayout.minimumLineSpacing = spacing
        
        dailyMissionFlowLayout.minimumInteritemSpacing = spacing
        
        guard let screenWidth = fullScreenSize?.width else { return }
        
        dailyMissionFlowLayout.headerReferenceSize = CGSize(width: screenWidth, height: 40.0)
        
    }

}

extension ListViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView
    ) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int
        
    ) -> Int {
        
        switch section {
            
        case 0:
            return dailyMissionUnDone.count
            
        case 1:
            return dailyMissionDone.count
            
        default:
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = dailyMissionCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DailyMissionCollectionViewCell.self), for: indexPath)
        
        guard let missionItem = item as? DailyMissionCollectionViewCell else { return UICollectionViewCell() }
        
        switch  indexPath.section {
            
        case 0:
            
            missionItem.dailyMissionLabel.text = dailyMissionUnDone[indexPath.row]
            missionItem.missionChargerLabel.text = missionCharger[indexPath.row]
            
        case 1:
            
            missionItem.dailyMissionLabel.text = dailyMissionDone[indexPath.row]
            missionItem.missionChargerLabel.text = missionCharger[indexPath.row]
            
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
        
        if let collection = self.dailyMissionCollectionView, let screenWidth = fullScreenSize?.width {
            
            let width = (screenWidth - totalSpacing) / numberOfItemsPerRow
            
            return CGSize(width: width, height: width)
            
        } else {
            
            return CGSize(width: 0, height: 0)
        }
    }
}
