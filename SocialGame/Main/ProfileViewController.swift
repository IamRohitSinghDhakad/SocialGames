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
    @IBOutlet weak var lblFollowersTitle: UILabel!
    @IBOutlet weak var lblFollowingTitle: UILabel!
    @IBOutlet weak var lblResetPassword: UILabel!
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    @IBOutlet weak var lblAboutUs: UILabel!
    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var lblChnageLanguage: UILabel!
    @IBOutlet weak var lblDeleteAccount: UILabel!
    
    var objUser : UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLanguage()
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
        self.call_GetProfile_Api()
    }
    
    func setLanguage(){
        
        self.lblHeaderTitle.text = "Profile".localized()
        self.lblFollowersTitle.text = "Followers".localized()
        self.lblFollowingTitle.text = "Following".localized()
        self.lblResetPassword.text = "Reset Password".localized()
        self.lblChnageLanguage.text = "Select Language".localized()
        self.lblContactUs.text = "Contact Us".localized()
        self.lblPrivacyPolicy.text = "Privacy Policy".localized()
        self.lblAboutUs.text = "About Us".localized()
        self.lblLogout.text = "Logout".localized()
        self.lblDeleteAccount.text = "Delete Account".localized()
        
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
        case 109:
            let vc = authStoryboard.instantiateViewController(withIdentifier: "SelectLanguageViewController")as! SelectLanguageViewController
            vc.isComingfrom = "Profile"
            self.navigationController?.pushViewController(vc, animated: true)
        case 110:
            objAlert.showAlertCallBack(alertLeftBtn: "Yes".localized(), alertRightBtn: "No".localized(), title: "".localized(), message: "Are you sure you want to delete your account permanently ?".localized(), controller: self) {
                self.call_DeleteProfile_Api()
            }
        default:
            objAlert.showAlertCallBack(alertLeftBtn: "Yes".localized(), alertRightBtn: "No".localized(), title: "Logout".localized(), message: "Are you sure want to Logout?".localized(), controller: self) {
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
    
    func call_DeleteProfile_Api(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_DeleteAccunt + objAppShareData.UserDetail.strUserId!, queryParams: [:], params: [:], strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? String {
                    
                    objAppShareData.signOut()
                    
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
