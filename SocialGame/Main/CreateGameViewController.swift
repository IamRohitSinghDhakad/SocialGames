//
//  CreateGameViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 13/02/24.
//

import UIKit
import iOSDropDown

class CreateGameViewController: UIViewController, LocationServiceDelegate {

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tfSelectGame: DropDown!
    @IBOutlet weak var tfTime: UITextField!
    @IBOutlet weak var tfdate: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var tfNumberPlayers: UITextField!
    @IBOutlet weak var lblCreateGameHeading: UILabel!
    @IBOutlet weak var lblSelectGame: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblNumberOfPlayers: UILabel!
    @IBOutlet weak var btnOnCreate: UIButton!
    
    var arrCategory = [String]()
    var arrcategoryID = [String]()
    
    var strCategoryID = ""
    var strLocation = ""
    var strLat = ""
    var strLong = ""
    
    var destinationLatitude = Double()
    var destinationLongitude = Double()
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var timeFormateToBeSend = ""
    
    var location: Location? {
        didSet {
            self.tfLocation.text = location.flatMap({ $0.title }) ?? "Select Location".localized()
            let cordinates = location.flatMap({ $0.coordinate })
            if (cordinates != nil){
                
                destinationLatitude = cordinates?.latitude ?? 0.0
                destinationLongitude = cordinates?.longitude ?? 0.0
              
                var xCordinate = ""
                var yCordinate = ""
                
                if let latitude = cordinates?.latitude {
                    xCordinate = "\(latitude)"
                }
                if let longitude = cordinates?.longitude{
                    yCordinate = "\(longitude)"
                }
                print(xCordinate)
                print(yCordinate)
                
                LocationService.shared.getAddressFromLatLong(plLatitude: xCordinate, plLongitude: yCordinate, completion: { (dictAddress) in
                    
                    let locality = dictAddress["locality"]as? String
                    let SubLocality = dictAddress["subLocality"]as? String
                    let throughFare = dictAddress["thoroughfare"]as? String
                    
                    if locality != ""{
                        self.tfLocation.text = locality
                    }else{
                        if SubLocality != ""{
                            self.tfLocation.text = SubLocality
                        }else{
                            if throughFare != ""{
                                self.tfLocation.text = throughFare
                            }
                        }
                    }
                    if let fullAddress = dictAddress["fullAddress"]as? String{
                        self.tfLocation.text = fullAddress
                    }else{
                        self.tfLocation.text = dictAddress["country"]as? String ?? ""
                    }
                    
                    LocationService.shared.stopUpdatingLocation()
                    
                }) { (Error) in
                    print(Error)
                }
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfdate.delegate = self
        self.setDatePicker()
        
        self.tfTime.delegate = self
        self.setTimePicker()
        
        self.call_GetCategory_Api()
        // Do any additional setup after loading the view.
        self.tfSelectGame.delegate = self
        
        self.tfSelectGame.didSelect { selectedText, index, id in
            self.strCategoryID = "\(id)"
        }
        
        location = nil
        LocationService.shared.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLanguage()
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
        
        if LocationService.shared.getPermission(){
            //LocationService.shared.startUpdatingLocation()
        }else{
            LocationService.shared.showAlertOfLocationNotEnabled()
        }
    }
    
    func setLanguage(){
        self.lblCreateGameHeading.text = "Create Game".localized()
        self.lblDate.text = "Date".localized()
        self.lblTime.text = "Time".localized()
        self.lblLocation.text = "Location".localized()
        self.lblSelectGame.text = "Select Game".localized()
        self.lblNumberOfPlayers.text = "Number of Players".localized()
        self.btnOnCreate.setTitle("Create".localized(), for: .normal)
    }
    
   
    
    func tracingLocation(currentLocation: [String : Any]) {
        
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        
    }
    
    @IBAction func btnOnLocation(_ sender: Any) {
        let sb = UIStoryboard.init(name: "LocationPicker", bundle: Bundle.main)
        let locationPicker = sb.instantiateViewController(withIdentifier: "LocationPickerViewController")as! LocationPickerViewController//segue.destination as! LocationPickerViewController
        locationPicker.location = location
        locationPicker.showCurrentLocationButton = true
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.selectCurrentLocationInitially = true
        
        locationPicker.completion = { self.location = $0 }
        
        self.navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    @IBAction func btnOnCreate(_ sender: Any) {
        if validateFields(){
            self.call_AddGame_Api()
        }
    }
    
    func setDatePicker() {
//        let calendar = Calendar(identifier: .gregorian)
//        
//        let currentDate = Date()
//        var components = DateComponents()
//        components.calendar = calendar
//        
//        components.year = -18
//        components.month = 12
//        let maxDate = calendar.date(byAdding: components, to: currentDate)!
//        
//        components.year = -150
//        let minDate = calendar.date(byAdding: components, to: currentDate)!
//        
//        datePicker.minimumDate = minDate
//        datePicker.maximumDate = maxDate
//        
        
        //Format Date
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done".localized(), style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.tfdate.inputAccessoryView = toolbar
        self.tfdate.inputView = datePicker
    }
    
    func setTimePicker() {
        
        //Format Date
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done".localized(), style: .plain, target: self, action: #selector(doneTimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.tfTime.inputAccessoryView = toolbar
        self.tfTime.inputView = timePicker
    }
    
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.tfdate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    
    @objc func doneTimePicker(){
        let formatter = DateFormatter()
        let formatterForAPI = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatterForAPI.dateFormat = "HH:mm"
        timeFormateToBeSend = formatterForAPI.string(from: timePicker.date)
        self.tfTime.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    
    func validateFields() -> Bool {
        
        guard let selectGame = tfSelectGame.text, !selectGame.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "Select Game".localized(), controller: self)
            return false
        }
        
        guard let time = tfTime.text, !time.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "Select Time".localized(), controller: self)
            return false
        }
        
        guard let date = tfdate.text, !date.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "Select Date".localized(), controller: self)
            return false
        }
        
        
        guard let location = tfLocation.text, !location.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "Select Location".localized(), controller: self)
            return false
        }
        
        guard let numberPlayers = tfNumberPlayers.text, !numberPlayers.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "PEnter Number of players required".localized(), controller: self)
            return false
        }
        // All validations pass
        return true
    }
}

extension CreateGameViewController {
    
    func call_GetCategory_Api(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
       
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId!]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetCategory, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    for data in user_details{
                        let obj = CategoryModel.init(from: data)
                        let catName = obj.category_name
                        self.arrCategory.append(catName?.localized() ?? "")
                        self.arrcategoryID.append(obj.category_id ?? "")
                        print(obj.category_id!)
                    }
                    self.tfSelectGame.optionArray = self.arrCategory
                    let intArray = self.arrcategoryID.map { Int($0)!}
                    self.tfSelectGame.optionIds = intArray
                    
                    self.tfSelectGame.reloadInputViews()
                    
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
    
    
    //Add Game API
    func call_AddGame_Api(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId!,
                         "category_id":self.strCategoryID,
                         "time":self.timeFormateToBeSend,
                         "date":self.tfdate.text!,
                         "location":self.tfLocation.text!,
                         "number_of_players":self.tfNumberPlayers.text!,
                         "lat":"\(self.destinationLatitude)",
                         "lng":"\(self.destinationLongitude)"]as [String:Any]
        
        #if DEBUG
        print(dicrParam)
        #endif
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_AddGame, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "", message: "Game Added Successfully".localized(), controller: self) {
                        
                        if let tabBarController = self.tabBarController {
                            tabBarController.selectedIndex = 1
                        }
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
