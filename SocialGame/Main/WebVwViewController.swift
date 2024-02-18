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

        // Do any additional setup after loading the view.
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
