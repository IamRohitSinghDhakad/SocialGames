//
//  CreateGameViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 13/02/24.
//

import UIKit
import iOSDropDown

class CreateGameViewController: UIViewController {

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tfSelectGame: DropDown!
    @IBOutlet weak var tfTime: UITextField!
    @IBOutlet weak var tfdate: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var tfNumberPlayers: UITextField!
    
    var arrCategory = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.call_GetCategory_Api()
        // Do any additional setup after loading the view.
        
        self.tfSelectGame.delegate = self
        
        self.tfSelectGame.didSelect { selectedText, index, id in
            print(selectedText)
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
    }

    @IBAction func btnOnCreate(_ sender: Any) {
        
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
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetCategory, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    for data in user_details{
                        let obj = CategoryModel.init(from: data)
                        var catName = obj.category_name
                        self.arrCategory.append(catName ?? "")
                    }
                    self.tfSelectGame.optionArray = self.arrCategory
                    
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
}
