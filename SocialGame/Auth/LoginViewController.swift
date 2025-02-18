//
//  LoginViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 12/02/24.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import FacebookLogin
import GoogleUtilities


class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblSignInSocial: UILabel!
    @IBOutlet weak var lblRegisterNow: UILabel!
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var lblAnonymousLogin: UILabel!
    @IBOutlet weak var lblOrSignInVia: UILabel!
    @IBOutlet weak var lblSignInHeading: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var appleSignIn: UIView!
    
    var loginAnynomous : Bool?
    var socialLogin : Bool?
    var strSocialID = ""
    var strSocialType = ""
    var strSocialName = ""
    var strSocialEmail = ""
    var isReadEULA = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        GIDSignIn.sharedInstance.clientID = "401365978958-7t197g8ijcseo39ne4oedtknqk9febfa.apps.googleusercontent.com"
        //        GIDSignIn.sharedInstance.delegate = self
        // Do any additional setup after loading the view.
        
        // Optionally customize the button's appearance
        // Ensure the button is of the correct type
               let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
               button.translatesAutoresizingMaskIntoConstraints = false
               button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
               
               // Add the button to the view
               self.appleSignIn.addSubview(button)
       // appleSignIn.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        self.performAppleSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setLanguageText()
    }
    
    @IBAction func btnAcceptEULA(_ sender: Any) {
        if isReadEULA == true {
            self.imgVw.image = self.imgVw.image == UIImage(named: "select") ? UIImage(named: "box") : UIImage(named: "select")
        }else{
            objAlert.showAlert(message: "Please read EULA first", controller: self)
        }
       
    }
    
    @IBAction func btnOnGoToEULAAggrement(_ sender: Any) {
        isReadEULA = true
        pushVc(viewConterlerId: "EULAViewController")
    }
    
    
    func setLanguageText(){
        self.lblSignInHeading.text = "Sign In".localized()
        self.lblEmail.text = "Email".localized()
        self.lblPassword.text = "Password".localized()
        self.btnLogin.setTitle("Login".localized(), for: .normal)
        self.btnForgotPassword.setTitle("Forgot Password?".localized(), for: .normal)
        self.lblSignInSocial.text = "or sign in via social account".localized()
        self.lblOrSignInVia.text = "or sign in via".localized()
        self.lblAnonymousLogin.text = "Anonymous Login!".localized()
        self.lblDontHaveAccount.text = "Don't have an account".localized()
        self.lblRegisterNow.text = "Register Now!".localized()
        
    }
    
    
    @IBAction func btnOnPassword(_ sender: Any) {
        self.tfPassword.isSecureTextEntry = self.tfPassword.isSecureTextEntry == true ? false : true
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        loginAnynomous = false
        if self.validateFields(){
            self.call_WsLogin()
        }
    }
    
    @IBAction func btnOnforgotPassword(_ sender: Any) {
        pushVc(viewConterlerId: "ForgotPasswordViewController")
    }
    
    @IBAction func btnOnSocialLogin(_ sender: UIButton) {
        guard self.imgVw.image == UIImage(named: "select") else {
               // Show an error message for not agreeing to the EULA
               objAlert.showAlert(message: "Please Agree to the EULA Terms and Conditions".localized(), controller: self)
               return
           }
        loginAnynomous = false
        switch sender.tag {
        case 0:
            self.performSignInWithGoogle()
        case 1:
            performAppleSignIn()
        default:
            print("FB")
        }
        
    }
    
    @IBAction func btnOnAnonymousLogin(_ sender: Any) {
        guard self.imgVw.image == UIImage(named: "select") else {
               // Show an error message for not agreeing to the EULA
               objAlert.showAlert(message: "Please Agree to the EULA Terms and Conditions".localized(), controller: self)
               return
           }
        loginAnynomous = true
        call_WsLogin()
    }
    
    @IBAction func btnOnregisterNow(_ sender: Any) {
        pushVc(viewConterlerId: "SignUpViewController")
    }
    
    func validateFields() -> Bool {
        guard let email = tfEmail.text, !email.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "Please Enter Email".localized(), controller: self)
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        guard emailPred.evaluate(with: email) else {
            // Show an error message for invalid email format
            objAlert.showAlert(message: "Email is not valid".localized(), controller: self)
            return false
        }
        
        guard let password = tfPassword.text, !password.isEmpty else {
            // Show an error message for empty password
            objAlert.showAlert(message: "Please Enter Password".localized(), controller: self)
            return false
        }
        
        guard self.imgVw.image == UIImage(named: "select") else {
               // Show an error message for not agreeing to the EULA
               objAlert.showAlert(message: "Please Agree to the EULA Terms and Conditions".localized(), controller: self)
               return false
           }
        
        // All validations pass
        return true
    }
    
}


// MARK: - Call API
extension LoginViewController {
    
    func call_WsLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
        
        if loginAnynomous == true{
            
            dicrParam = ["device_type":"IOS",
                         "device_id":objAppShareData.uuidString,
                         "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
            url = WsUrl.url_AnonymousLogin
            
        }else if socialLogin == true{
            dicrParam = ["name":self.strSocialName,
                         "email":self.strSocialEmail,
                         "social_id":self.strSocialID,
                         "social_type":self.strSocialType,
                         "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
            
            url = WsUrl.url_SocialLogin
            
        }else{
            dicrParam = ["username":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
            
            url = WsUrl.url_Login
        }
        
        print(dicrParam)
        
        
        
        objWebServiceManager.requestGet(strURL: url, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    self.setRootController()
                    
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
    
    func setRootController(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
}


//MARK: Apple Login
extension LoginViewController :  ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Handle the user's Apple ID credential
            let userIdentifier = appleIDCredential.user
            // You can use userIdentifier to identify the user in your system
            print("User ID: \(userIdentifier)")
            self.strSocialID = "\(userIdentifier)"
            self.strSocialType = "apple"
            // You can also access user's full name and email
            if let fullName = appleIDCredential.fullName,
               let email = appleIDCredential.email {
                print("Full Name: \(fullName.givenName ?? "") \(fullName.familyName ?? "")")
                print("Email: \(email)")
               
            }
            self.strSocialName = appleIDCredential.fullName?.givenName ?? ""
            self.strSocialEmail = appleIDCredential.email ?? ""
            self.socialLogin = true
            self.call_WsLogin()
            // Proceed with your authentication or registration logic here
            // Call your API or navigate to the next screen
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle errors during Apple Sign-In
        print("Apple Sign-In Error: \(error.localizedDescription)")
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Return the window or view where you want to present the Apple Sign-In dialog
        return self.view.window ?? ASPresentationAnchor()
    }
    
}

//MARK: Google Sign In

extension LoginViewController {
    
    func performSignInWithGoogle() {
        // Start the sign in flow!
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            
            if let error = error {
                // If there's an error, show it in an alert
                self.showAlert(with: "Sign In Error", message: error.localizedDescription)
                return
            }
            
            guard let signInResult = signInResult else {
                // If signInResult is nil, show a generic error message
                self.showAlert(with: "Sign In Error", message: "An unknown error occurred.")
                return
            }
            
            self.socialLogin = true
//            print(signInResult.user.profile?.name)
//            print(signInResult.user.profile?.givenName)
//            print(signInResult.user.profile?.familyName)
//            print(signInResult.user.idToken?.tokenString ?? "")
            self.strSocialID = "\(signInResult.user.idToken?.tokenString ?? "")"
            self.strSocialType = "google"
            self.strSocialName = signInResult.user.profile?.name ?? ""
            self.strSocialEmail = signInResult.user.profile?.email ?? ""
            self.call_WsLogin()
        }
    }

    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    //    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
    //              withError error: Error!) {
    //        // Perform any operations when the user disconnects from app here.
    //    }
    //
    //    //Google sign
    //    func sign(_ signIn: GIDSignIn!,present viewController: UIViewController!) {
    //        self.present(viewController, animated: true, completion: nil)
    //    }
    //    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
    //        self.dismiss(animated: false, completion: nil)
    //    }
    
}


