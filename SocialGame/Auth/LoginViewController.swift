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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        GIDSignIn.sharedInstance.clientID = "401365978958-7t197g8ijcseo39ne4oedtknqk9febfa.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnOnPassword(_ sender: Any) {
        self.tfPassword.isSecureTextEntry = self.tfPassword.isSecureTextEntry ? true : false
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        if self.validateFields(){
            self.call_WsLogin()
        }
    }
    
    @IBAction func btnOnforgotPassword(_ sender: Any) {
        pushVc(viewConterlerId: "ForgotPasswordViewController")
    }
    
    @IBAction func btnOnSocialLogin(_ sender: UIButton) {
        
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
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
        
        let dicrParam = ["username":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Login, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
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
            
            // You can also access user's full name and email
            if let fullName = appleIDCredential.fullName,
               let email = appleIDCredential.email {
                print("Full Name: \(fullName.givenName ?? "") \(fullName.familyName ?? "")")
                print("Email: \(email)")
            }
            
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
    
    func performSignInWithGoogle(){
        // Start the sign in flow!
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            print(error)
            print(signInResult?.user)
            print(signInResult?.user.idToken)
            // check `error`; do something with `signInResult`
        }
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


