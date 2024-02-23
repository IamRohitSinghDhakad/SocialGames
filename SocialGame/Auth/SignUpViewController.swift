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
    
    var strSelectGender = ""
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfDateOfBirth.delegate = self
        self.setDatePicker()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnOnRegister(_ sender: Any) {
        if self.validateFields(){
            self.call_WsRegisterUser()
        }
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnGenderSelection(_ sender: UIButton) {
        
        switch sender.tag {
        case 4:
            print("Male")
            strSelectGender = "Male"
        case 5:
            print("Female")
            strSelectGender = "Female"
        case 6:
            print("Other")
            strSelectGender = "Other"
        default:
            break
        }
    }
    
    func setDatePicker() {
        let calendar = Calendar(identifier: .gregorian)
        
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        components.year = -18
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        components.year = -150
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        
        //Format Date
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.tfDateOfBirth.inputAccessoryView = toolbar
        self.tfDateOfBirth.inputView = datePicker
    }
    
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.tfDateOfBirth.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    
    func validateFields() -> Bool {
        
        guard let fullName = tfFullName.text, !fullName.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "Please Enter Full Name".localized(), controller: self)
            return false
        }
        
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
        
        guard let mobileNumber = tfMobileNumber.text, !mobileNumber.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "Please Enter Mobile Number".localized(), controller: self)
            return false
        }
        
        guard let dob = tfDateOfBirth.text, !dob.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "Please Select Date of Birth".localized(), controller: self)
            return false
        }
        
        guard let password = tfPassword.text, !password.isEmpty else {
            // Show an error message for empty password
            objAlert.showAlert(message: "Please Enter Password".localized(), controller: self)
            return false
        }
        
        guard !self.strSelectGender.isEmpty else {
            // Show an error message for empty gender
            objAlert.showAlert(message: "Please select Gender".localized(), controller: self)
            return false
        }

        // All validations pass
        return true
    }
}


// MARK: - Call API
extension SignUpViewController {
    
    func call_WsRegisterUser(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()

        
        var dicrParam = [String:Any]()
            dicrParam = ["name":self.tfEmail.text!,
                         "email":self.tfEmail.text!,
                         "mobile":self.tfMobileNumber.text!,
                         "dob":self.tfDateOfBirth.text!,
                         "gender":self.strSelectGender,
                         "password":self.tfPassword.text!,
                         "register_id":objAppShareData.strFirebaseToken]as [String:Any]
        
        
        
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
