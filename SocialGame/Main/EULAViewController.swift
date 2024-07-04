//
//  EULAViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 02/07/24.
//

import UIKit
import WebKit

class EULAViewController: UIViewController {

    @IBOutlet weak var webKit: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        if let url = URL(string: BASE_URL + "page/EULA%20Certificate") {
            print(url)
            
            let request = URLRequest(url: url)
            self.webKit.load(request)
            
        }
    }
    

    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
   
}


extension EULAViewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler{
    
    // WKNavigationDelegate methods
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Called when the web view finishes loading a page
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Called when the web view fails to load a page
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // Called when the web view begins to receive content
    }
    
    // WKUIDelegate methods
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Called when a link with target="_blank" is clicked
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        // Called when a web view that was created programmatically is closed
    }
    
    // WKScriptMessageHandler methods
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Called when a JavaScript message is received from the web view
    }
}
