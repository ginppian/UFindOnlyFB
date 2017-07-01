//
//  TerminosViewController.swift
//  UFind
//
//  Created by ginppian on 27/02/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit

class TerminosViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var bandera = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        
        self.cargarPdf(nombre: "documento", webView: self.webView)

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

    func cargarPdf(nombre:String, webView:UIWebView){
        if let pdf = Bundle.main.url(forResource: nombre, withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
        
        //Habilita Pitch Gestur y Zoom
        webView.scalesPageToFit = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
