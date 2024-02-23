//
//  OtherUserProfileViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 18/02/24.
//

import UIKit

class OtherUserProfileViewController: UIViewController {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    
    var userID = ""
    var objUser : UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        call_GetProfile_Api()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
}


extension OtherUserProfileViewController {
    
    func call_GetProfile_Api(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":self.userID,
                         "login_id":objAppShareData.UserDetail.strUserId!]as [String:Any]
        
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
                    self.lblMobileNumber.text = self.objUser?.mobile
                    self.lblFollowers.text = self.objUser?.strFollowers
                    self.lblFollowing.text = self.objUser?.strFollowing
                    
                    let imageUrl  = self.objUser?.userImage
                    if imageUrl != "" {
                        let url = URL(string: imageUrl ?? "")
                        self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user 1"))
                    }else{
                        self.imgVwUser.image = #imageLiteral(resourceName: "user 1")
                    }
                    
                    if self.objUser?.isFollowed == "1" {
                        
                    }else{
                        
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
