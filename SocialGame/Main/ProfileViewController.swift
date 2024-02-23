//
//  ProfileViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 13/02/24.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    
    var objUser : UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
        self.call_GetProfile_Api()
    }
    

    @IBAction func btnOnEditProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController")as! EditProfileViewController
        vc.objUser = self.objUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnActions(_ sender: UIButton) {
        
        switch sender.tag {
        case 101:
            pushVc(viewConterlerId: "ResetPasswordViewController")
        case 102:
            pushVc(viewConterlerId: "ContactUsViewController")
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


extension ProfileViewController {
    
    func call_GetProfile_Api(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId!]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                   
                    self.objUser = UserModel.init(from: user_details)
                    
                    self.lblEmail.text = self.objUser?.email
                    self.lblUserName.text = self.objUser?.name
                    self.lblPassword.text = self.objUser?.mobile
                    self.lblFollowersCount.text = self.objUser?.strFollowers
                    self.lblFollowingCount.text = self.objUser?.strFollowing
                    
                    let imageUrl  = self.objUser?.userImage
                    if imageUrl != "" {
                        let url = URL(string: imageUrl ?? "")
                        self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo_one"))
                    }else{
                        self.imgVwUser.image = #imageLiteral(resourceName: "logo_one")
                    }
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
            
            
        } failure: { (Error) in
            //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
