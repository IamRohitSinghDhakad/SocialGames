//
//  ProfileViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 13/02/24.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    
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
    

    @IBAction func btnOnEditProfile(_ sender: Any) {
        pushVc(viewConterlerId: "EditProfileViewController")
    }
    
    @IBAction func btnActions(_ sender: UIButton) {
        
        switch sender.tag {
        case 101:
            pushVc(viewConterlerId: "ResetPasswordViewController")
        case 102:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebVwViewController")as! WebVwViewController
            vc.isComingfrom = "Contact Us"
            self.navigationController?.pushViewController(vc, animated: true)
        case 103:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebVwViewController")as! WebVwViewController
            vc.isComingfrom = "Privacy Policy"
            self.navigationController?.pushViewController(vc, animated: true)
        case 104:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebVwViewController")as! WebVwViewController
            vc.isComingfrom = "About Us"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "Logout?", message: "Are you sure you want to logout", controller: self) {
                objAppShareData.signOut()
            }
            
        }
    }
}
