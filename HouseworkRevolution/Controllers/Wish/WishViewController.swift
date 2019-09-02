//
//  WishViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class WishViewController: UIViewController {

    let placeHolder = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLamp()
        makeWishView.isHidden = true
        wishInput.delegate = self

    }
    
    @IBOutlet weak var makeWishView: UIView!
    
    // 神燈相關設定：待換圖、建立小動畫
    @IBOutlet weak var lamp: UIImageView!
    
    func setUpLamp(){
        
        lamp.isUserInteractionEnabled = true
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapOnImage))
        
        lamp.addGestureRecognizer(touch)
    }

    @objc func tapOnImage() {
        
        makeWishView.isHidden = false
       
    }
    // 以上為神燈點擊事件
    
    @IBOutlet weak var wishInput: UITextView!
    
    @IBAction func cancelWish(_ sender: UIButton) {
        
        makeWishView.isHidden = true
    }
    
    @IBAction func makeWish(_ sender: UIButton) {
        // TODO: 將願望加到 database
    }
    
    
}

extension WishViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        wishInput.text = ""
        wishInput.textColor = UIColor.noticeGray
        wishInput.font = UIFont(name: "Helvetica Neue", size: 17.0)
    }
}
