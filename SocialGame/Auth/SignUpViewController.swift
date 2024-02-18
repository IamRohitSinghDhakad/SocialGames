//
//  SignUpViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 13/02/24.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfMobileNumber: UITextField!
    @IBOutlet weak var tfDateOfBirth: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var imgVwMale: UIImageView!
    @IBOutlet weak var imgVwFemale: UIImageView!
    @IBOutlet weak var imgVwOther: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnOnRegister(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnGenderSelection(_ sender: UIButton) {
        
        switch sender.tag {
        case 4:
            print("Male")
        case 5:
            print("Female")
        case 6:
            print("Other")
        default:
            break
        }
    }
}
