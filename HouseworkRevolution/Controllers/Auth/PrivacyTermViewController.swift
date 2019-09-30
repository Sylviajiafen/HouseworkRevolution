//
//  PrivacyTermViewController.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/25.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import WebKit

class PrivacyTermViewController: UIViewController {

    @IBOutlet weak var privacyWebView: WKWebView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      linkToPrivacy()
    }
    
    func linkToPrivacy() {
        
        privacyWebView.navigationDelegate = self
        
        guard let privacyURL = URL(string:
                    "https://www.privacypolicies.com/privacy/view/0776e10a3962811581f3623d374a64b9")
            else { return }
        
        let request = URLRequest(url: privacyURL)
        
        privacyWebView.load(request)
    }

    @IBAction func dismissPrivacy(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension PrivacyTermViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        loadingIndicator.stopAnimating()
    }
}
