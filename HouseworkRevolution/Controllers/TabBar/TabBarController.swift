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
                
                controller = UIStoryboard.auth.instantiateInitialViewController()!
            
            case .mission:
                
                controller = UIStoryboard.mission.instantiateInitialViewController()!
            
            case .wish:
                
                controller = UIStoryboard.wish.instantiateInitialViewController()!
            
            case .family:
                
                controller = UIStoryboard.family.instantiateInitialViewController()!
            
        }
        
        //TODO
        controller.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icons8-heart"), selectedImage: UIImage(named: "icons8-heart"))
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        
        return controller
    }
}
