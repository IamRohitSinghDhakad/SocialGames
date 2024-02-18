//
//  ForgotPasswordViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 12/02/24.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func btnOnSend(_ sender: Any) {
        
    }
    
    @IBAction func btnOnGoBack(_ sender: Any) {
        onBackPressed()
        
    }
}
