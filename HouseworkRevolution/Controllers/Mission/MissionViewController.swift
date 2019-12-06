//  MissionViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/8/29.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class MissionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showAddMission(_ sender: UISwipeGestureRecognizer) {
        
        let addMissionViewController = UIStoryboard.mission.instantiateViewController(
            withIdentifier: String(describing: AddMissionViewController.self))
        
        guard let targetView = addMissionViewController
            as? AddMissionViewController else { return }
        
        targetView.modalPresentationStyle = .fullScreen
        
        present(targetView, animated: true, completion: nil)
    }
    
    @IBAction func showCheckMission(_ sender: Any) {
        
        let checkMissionViewController = UIStoryboard.mission.instantiateViewController(
            withIdentifier: String(describing: CheckMissionViewController.self))
        
        guard let targetView = checkMissionViewController
            as? OCCheckMissionViewController else { return }
        
        targetView.modalPresentationStyle = .fullScreen
        
        present(targetView, animated: true, completion: nil)
    }
}
