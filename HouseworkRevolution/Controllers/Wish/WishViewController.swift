//
//  WishViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class WishViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLamp()
        
        makeWishView.alpha = 0
        
        wishInput.delegate = self

    }
    
    @IBOutlet weak var makeWishView: UIView!
    
    var wishContent: String?  // 待決定是否保留
    
    // 神燈相關設定：待換圖、建立小動畫
    @IBOutlet weak var lamp: UIImageView!
    
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
    // 以上為神燈點擊事件
    
    @IBOutlet weak var wishInput: UITextView!
    
    @IBAction func makeWish(_ sender: UIButton) {
        // TODO: 將願望加到 database
        showMakeWish()
        wishContent = wishInput.text
    }
    
    // 待決定去留
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? ShowWishesViewController,
              let wish = wishContent else { return }
        
        destination.wishArr.append(wish)
    }
    
    func showMakeWish() {
        
        let alert = UIAlertController(title: nil, message: "許願成功", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        makeWishView.alpha = 0
    }
}

extension WishViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        wishInput.text = ""
        wishInput.textColor = UIColor.noticeGray
        wishInput.font = UIFont(name: "Helvetica Neue", size: 17.0)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = wishInput.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 100
    }
}
