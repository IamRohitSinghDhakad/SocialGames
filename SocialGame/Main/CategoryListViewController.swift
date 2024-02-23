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
    var games: [Game] = []
    var arrPlayers = [GetGameModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.lblHeaderTitle.text = categoryName
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "GamesTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "GamesTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        call_GetCategoryList_Api(strCategoryID: self.categoryId)
        
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
    }

    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnMapview(_ sender: Any) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "MapLocationViewController")as! MapLocationViewController
        vc.games = self.games
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    
    func getAllLatLong(){
        for gameData in self.arrPlayers {
            if let latitude = Double(gameData.lat ?? "0.0"),
               let longitude = Double(gameData.lng ?? "0.0") {
                let game = Game(
                    gameId: gameData.game_id ?? "",
                    categoryName: gameData.category_name ?? "",
                    creatorName: gameData.creator_name ?? "",
                    latitude: latitude,
                    longitude: longitude
                )
                games.append(game)
                print(game)
            }
        }

    }
    
}


extension CategoryListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamesTableViewCell")as! GamesTableViewCell
        
        let obj = self.arrPlayers[indexPath.row]
        
        cell.lblCategory.text = obj.creator_name
        
        cell.lblDate.text = obj.date
        cell.lblTime.text = obj.time
        
        cell.lblLocation.text = obj.location
        
        let imageUrl  = obj.category_image
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo_one"))
        }else{
            cell.imgVw.image = #imageLiteral(resourceName: "logo_one")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController")as! GameDetailViewController
        vc.objGameData = self.arrPlayers[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        let dicrParam = ["login_id":objAppShareData.UserDetail.strUserId!,
                         "category_id":categoryId,
                         "user_id":""]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetGame, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrPlayers.removeAll()
                    for data in user_details{
                        let obj = GetGameModel.init(from: data)
                        self.arrPlayers.append(obj)
                    }
                    self.tblVw.reloadData()
                    self.getAllLatLong()
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
