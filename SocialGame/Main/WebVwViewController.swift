//
//  WebVwViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 18/02/24.
//

import UIKit
import WebKit

class WebVwViewController: UIViewController {
    
    @IBOutlet weak var webVw: WKWebView!
    @IBOutlet weak var lblHeadingTitle: UILabel!
    @IBOutlet weak var vwHeader: UIView!
    
    
    var isComingfrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeadingTitle.text = self.isComingfrom
        
        self.webVw.navigationDelegate = self
        self.webVw.uiDelegate = self
        
        var loadUrl = ""
        switch isComingfrom {
        case "Privacy Policy":
            loadUrl = "page/Privacy"
        case "About Us":
            loadUrl = "page/About%20us"
        default:
            break
        }
        
        
        // Do any additional setup after loading the view.
        if let url = URL(string: BASE_URL + loadUrl) {
            print(url)
            
            let request = URLRequest(url: url)
            self.webVw.load(request)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
    }
    
    @IBAction func btnOnback(_ sender: Any) {
        onBackPressed()
    }
}



extension WebVwViewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler{
    
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
