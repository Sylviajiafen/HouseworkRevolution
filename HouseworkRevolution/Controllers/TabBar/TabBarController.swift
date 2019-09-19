//
//  TabBarController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/28.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [.list, .mission, .wish, .family]
    
    let layerGradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
    }
}

private enum Tab {
    
    case list
    
    case mission
    
    case wish
    
    case family
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
            case .list:
                
                controller = UIStoryboard.list.instantiateInitialViewController()!
            
            case .mission:
                
                controller = UIStoryboard.mission.instantiateInitialViewController()!
            
            case .wish:
                
                controller = UIStoryboard.wish.instantiateInitialViewController()!
            
            case .family:
                
                controller = UIStoryboard.family.instantiateInitialViewController()!
            
        }
        
        controller.tabBarItem = tabBarItem()
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 6.0, bottom: -6.0, right: -6.0)
        
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .list:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.listUnselected),
                selectedImage: UIImage.asset(.listSelected)
            )
            
        case .mission:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.missionUnselected),
                selectedImage: UIImage.asset(.missionSelected)
            )
            
        case .wish:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.wishUnselected),
                selectedImage: UIImage.asset(.wishSelected)
            )
            
        case .family:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.familyUnselected),
                selectedImage: UIImage.asset(.familySelected)
            )

        }
    }
}
