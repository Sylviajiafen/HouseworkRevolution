//
//  JGProgressHUDWrapper.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/17.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import JGProgressHUD

class ProgressHUD {
    
    static let shared = ProgressHUD()
    
    private init() {}
    
    let hud = JGProgressHUD(style: .dark)
    
    var view: UIView {
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate

        return appdelegate!.window!.rootViewController!.view
    }
    
    static func show() {
        
        if !Thread.isMainThread {
            
            DispatchQueue.main.async {
                show()
            }
            
            return
        }
        
        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        
        shared.hud.textLabel.text = "Loading"
        
        shared.hud.show(in: shared.view)
    }
    
    static func dismiss() {
        
        if !Thread.isMainThread {
            
            DispatchQueue.main.async {
                dismiss()
            }
            
            return
        }
        
        shared.hud.dismiss()
    }
    
    static func showＷith(text: String, _ view: UIView = shared.view, delay: Double = 0.7) {
        
        if !Thread.isMainThread {
            
            DispatchQueue.main.async {
                showＷith(text: text)
            }
            
            return
        }
        
        shared.hud.textLabel.text = text
        
        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        
        shared.hud.show(in: view)
        
        shared.hud.dismiss(afterDelay: delay)
    }

}
