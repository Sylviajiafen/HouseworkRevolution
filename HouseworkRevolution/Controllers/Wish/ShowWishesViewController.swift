//
//  ShowWishesViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class ShowWishesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wishesCollectionView.dataSource = self
        
        if let layout = wishesCollectionView.collectionViewLayout as? ShowWishesLayout {
            
            layout.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        wishes = wishArr.shuffled()
    }
    
    @IBAction func backToRoot(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var wishesCollectionView: UICollectionView!
    
    // TODO: 抓 dataBase 資料
    var wishArr: [String] = ["看電影", "寫小說", "睡到自然醒", "通宵追劇", "回娘家", "和老公離婚", "買下那個包！", "很長很長很長很長很長很長很長很長的願望"]
    
    var wishes = [String]()
    
    var wishContentHeight: CGFloat?
}

extension ShowWishesViewController: UICollectionViewDataSource, ShowWishesLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        
        return wishArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = wishesCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: WishCollectionViewCell.self), for: indexPath)
        
        guard let wishCell = cell as? WishCollectionViewCell else { return UICollectionViewCell() }
        
        wishCell.wishContent.text = wishes[indexPath.row]
        
        // TODO: 刪除願望是刪除 shuffled arr ，所以刪除後要把整個 shuffled 過的願望傳到雲端洗掉之前的 wish arr
        
        return wishCell
    }
    
    func collectionView(_collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
    
        let randomHeight = Int.random(in: 50...300)
        
        guard let wishContentHeight = wishContentHeight else { return CGFloat(randomHeight) }
        
        switch  randomHeight % 5 {
            
        case 0:
            return 10.0

        case 1:
            return 20.0

        case 2:
            return 30.0

        case 3:
            return 40.0

        case 4:
            return 50.0

        default:
            return CGFloat(randomHeight)
        }

    }
    
}
