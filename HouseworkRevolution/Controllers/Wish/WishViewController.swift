//
//  WishViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class WishViewController: UIViewController {

    @IBOutlet weak var makeWishView: UIView!
    
    @IBOutlet weak var lamp: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLamp()
        
        makeWishView.alpha = 0
        
        wishInput.delegate = self
        
        wishInput.text = defaultWish
    }
    
    let defaultWish = "有什麼願望是被家事耽擱的呢？"
    
    func setUpLamp() {
        
        lamp.isUserInteractionEnabled = true
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapOnImage))
        
        lamp.addGestureRecognizer(touch)
    }

    @objc func tapOnImage() {
    
        lamp.rotate()
        
        if makeWishView.alpha == 0 {
        
            UIView.animate(withDuration: 1.5) { [weak self] in
            
                self?.makeWishView.alpha = 1
            }
            
        } else {
            
            UIView.animate(withDuration: 1) { [weak self] in
                
                self?.makeWishView.alpha = 0
            }
        }
    }
    
    @IBOutlet weak var wishInput: UITextView!
    
    @IBAction func makeWish(_ sender: UIButton) {
        
        guard wishInput.text != "" && wishInput.text != defaultWish
            else { showMakeWish(message: "忘記留下願望了啦", wishInput: 1.0); return }
        
        guard let newWish = wishInput.text else { return }
    
        FirebaseUserHelper.shared.addWishOf(content: newWish)
        
        makeWishView.alpha = 0.0
        
        wishInput.clearText()
    }
    
    func showMakeWish(message: String, wishInput viewAlpha: CGFloat) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel)
        
        action.setValue(UIColor.lightGreen, forKey: "titleTextColor")
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        makeWishView.alpha = viewAlpha
        
        wishInput.setUpBy(text: defaultWish,
                          font: UIFont(name: "Helvetica Neue", size: 14.0),
                          textColor: UIColor.lightGray)
    }
}

extension WishViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        wishInput.setUpBy(font: UIFont(name: "Helvetica Neue", size: 17.0),
                          textColor: UIColor.noticeGray)
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        let currentText = wishInput.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 39
    }
    
}
