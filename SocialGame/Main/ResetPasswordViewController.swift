//
//  ResetPasswordViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 18/02/24.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var tfNewPasswword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var vwHeader: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
    }
    
    @IBAction func btnOnOldPassword(_ sender: Any) {
    }
    

    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
        
    }
    @IBAction func btnOnNewPassword(_ sender: Any) {
        
    }
    @IBAction func btnOnConfirmPassword(_ sender: Any) {
        
    }
    @IBAction func btnOnSubmit(_ sender: Any) {
    }
}
