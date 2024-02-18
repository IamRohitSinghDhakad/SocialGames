//
//  EditProfileViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 18/02/24.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfmobileNumber: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnUpdateProfile(_ sender: Any) {
    }
    
    @IBAction func btnOnUpdate(_ sender: Any) {
        
    }
    
}
