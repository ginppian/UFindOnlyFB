//
//  WebViewController.swift
//  UFind
//
//  Created by ginppian on 14/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    //Outlets
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    //Propertys
    //Recibimos link from GeneralViewController
    var link = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.delegate = self
        
        let url = NSURL (string: self.link)
        let requestObj = NSURLRequest(url: url! as URL);
        webView.loadRequest(requestObj as URLRequest)
    
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        self.activity.isHidden = false
        self.activity.startAnimating()
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.activity.stopAnimating()
        self.activity.isHidden = true
    }

}
