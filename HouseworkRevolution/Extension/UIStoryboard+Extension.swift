//
//  UIStoryboard+Extension.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/28.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    
    static let list = "List"
    
    static let mission = "Mission"
    
    static let wish = "Wish"
    
    static let family = "Family"
    
    static let auth = "Auth"
    
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return storyboard(name: StoryboardCategory.main) }
    
    static var list: UIStoryboard { return storyboard(name: StoryboardCategory.list) }
    
    static var mission: UIStoryboard { return storyboard(name: StoryboardCategory.mission) }
    
    static var wish: UIStoryboard { return storyboard(name: StoryboardCategory.wish) }
    
    static var family: UIStoryboard { return storyboard(name: StoryboardCategory.family) }
    
    static var auth: UIStoryboard { return storyboard(name: StoryboardCategory.auth) }
    
    private static func storyboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
