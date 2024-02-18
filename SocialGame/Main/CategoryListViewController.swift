//
//  CategoryListViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 17/02/24.
//

import UIKit
import GoogleMaps

class CategoryListViewController: UIViewController {

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    
    var categoryId = ""
    var categoryName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblHeaderTitle.text = categoryName
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "GamesTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "GamesTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
    }

    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnMapview(_ sender: Any) {
        
    }
    
}


extension CategoryListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamesTableViewCell")as! GamesTableViewCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVc(viewConterlerId: "GameDetailViewController")
    }

}


extension CategoryListViewController {
    
    func call_GetCategoryList_Api(strCategoryID: String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId!,
                         "category_id":categoryId]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetCategory, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    for data in user_details{
                     //   let obj = CategoryModel.init(from: data)
                     //   self.arrCategory.append(obj)
                    }
                  //  self.cvCategories.reloadData()
                    
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
