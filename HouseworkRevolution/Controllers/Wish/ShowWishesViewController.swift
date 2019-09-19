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
        
        wishesCollectionView.delegate = self
        
        if let layout = wishesCollectionView.collectionViewLayout as? ShowWishesLayout {
            
            layout.delegate = self
        }
        
        emptyView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        ProgressHUD.show(self.view)
        
        FirebaseUserHelper.shared.readWishesOf(user: StorageManager.userInfo.userID) { [weak self] (wishesInLamp) in
            
            if wishesInLamp.count == 0 {
                
                self?.emptyView.isHidden = false
                ProgressHUD.dismiss()
                
            } else {
            
                self?.wishArr = wishesInLamp
            
                self?.wishes = self?.wishArr.shuffled() ?? []
            }
        }
    }
    
    @IBOutlet weak var emptyView: UIView!
    
    @IBAction func backToRoot(_ sender: UIButton) {
        
        emptyView.isHidden = true
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var wishesCollectionView: UICollectionView!
    
    var wishArr = [String]()
    
    var wishes = [String]() {
        
        didSet {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.wishesCollectionView.reloadData()
                
                self?.wishesCollectionView.collectionViewLayout.invalidateLayout()
                
                ProgressHUD.dismiss()
            }
        }
    }
    
    var height: CGFloat?
    
}

extension ShowWishesViewController: UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    ShowWishesLayoutDelegate,
                                    WishCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        
        return wishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = wishesCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: WishCollectionViewCell.self), for: indexPath)
        
        guard let wishCell = cell as? WishCollectionViewCell else { return UICollectionViewCell() }
        
        wishCell.delegate = self
        
        height = wishCell.frame.height
        
        wishCell.wishContent.text = wishes[indexPath.row]
        
        wishCell.showDelete()
        
        if wishes.count == 1 {
            
            wishCell.blockDelete()
        }
        
        return wishCell
    }
    
    func collectionView(_collectionView: UICollectionView,
                        heightForItemAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        
        let randomHeight = CGFloat.random(in: 60...300)
        
        if randomHeight == height {

            height = CGFloat.random(in: 60...300)

            return height ?? 60.0

        } else {

            return randomHeight
        }
        
    }
    
    func userDidHitDelete(_ cell: UICollectionViewCell) {
        
        guard let toBeRemovedIndex = wishesCollectionView.indexPath(for: cell) else { return }
        
        FirebaseUserHelper.shared.removeWishOf(content: wishes[toBeRemovedIndex.row],
                                               user: StorageManager.userInfo.userID)
        
        wishes.remove(at: toBeRemovedIndex.row)
    }
}
