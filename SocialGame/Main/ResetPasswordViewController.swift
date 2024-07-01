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
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblOldPassword: UILabel!
    @IBOutlet weak var lblNewPassword: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    
    
    var strOldPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setlanguage()
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
    }
    
    func setlanguage(){
        self.lblHeader.text = "Reset Password".localized()
        self.lblOldPassword.text = "Old Password".localized()
        self.lblNewPassword.text = "New Password".localized()
        self.lblConfirmPassword.text = "Confirm Password".localized()
        self.btnUpdate.setTitle("Update".localized(), for: .normal)
    }
    
    
    @IBAction func btnOnOldPassword(_ sender: Any) {
        self.tfOldPassword.isSecureTextEntry = self.tfOldPassword.isSecureTextEntry == true ? false : true
    }

    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnNewPassword(_ sender: Any) {
        self.tfNewPasswword.isSecureTextEntry = self.tfNewPasswword.isSecureTextEntry == true ? false : true
    }
    
    @IBAction func btnOnConfirmPassword(_ sender: Any) {
        self.tfConfirmPassword.isSecureTextEntry = self.tfConfirmPassword.isSecureTextEntry == true ? false : true
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        if validatePassword() {
            self.call_WsResetPassword()
        }
    }
    
    func validatePassword() -> Bool {
        guard let oldPassword = self.tfOldPassword.text, !oldPassword.isEmpty,
              let newPassword = self.tfNewPasswword.text, !newPassword.isEmpty,
              let confirmPassword = self.tfConfirmPassword.text, !confirmPassword.isEmpty
        else {
            objAlert.showAlert(message: "Please fill in all fields.".localized(), controller: self)
            return false
        }
        
        // Check if old password matches the stored old password
     //   if oldPassword == strOldPassword {
            // Check if new password and confirm password match
            if newPassword == confirmPassword {
                return true
            } else {
                objAlert.showAlert(message: "Enter valid password".localized(), controller: self)
                return false
            }
//        }
//        else {
//            objAlert.showAlert(message: "Old Password is incorrect.".localized(), controller: self)
//            return false
//        }
    }

}


extension ResetPasswordViewController {
    
    func call_WsResetPassword(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        dicrParam = ["old_password":self.tfOldPassword.text!,
                     "new_password":self.tfNewPasswword.text!,
                     "user_id":objAppShareData.UserDetail.strUserId!
        ]
        print(dicrParam)
                     
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_ChangePassword, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK".localized(), title: "", message: "Password reset successfully".localized(), controller: self) {
                        self.onBackPressed()
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
