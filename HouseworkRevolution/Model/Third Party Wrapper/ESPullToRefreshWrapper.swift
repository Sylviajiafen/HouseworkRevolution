//
//  ESPullToRefreshWrapper.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/19.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import ESPullToRefresh

extension UITableView {
    
    func addPullToRefresh(_ tableView: UITableView, handler: @escaping () -> Void) {
        
        tableView.es.addPullToRefresh {
            
            handler()
        }
    }
    
    func endPullToRefresh(_ tableView: UITableView) {
        
        tableView.es.stopPullToRefresh()
    }
    
}

extension UICollectionView {
    
    func addPullToRefresh(_ collectionView: UICollectionView, handler: @escaping () -> Void) {
        
        collectionView.es.addPullToRefresh {
            
            handler()
        }
    }
    
    func endPullToRefresh(_ collectionView: UICollectionView) {
        
        collectionView.es.stopPullToRefresh()
    }
}
