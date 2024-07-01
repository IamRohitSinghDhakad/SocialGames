//
//  GamesViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 13/02/24.
//

import UIKit

class GamesViewController: UIViewController {

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var vwMyGames: UIView!
    @IBOutlet weak var vwJoinedGames: UIView!
    @IBOutlet weak var btnMyGames: UIButton!
    @IBOutlet weak var btnJoinedGames: UIButton!
    @IBOutlet weak var lblGamesHeading: UILabel!
    
    
    var arrMyGames = [GetGameModel]()
    
    var isJoinedGames : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "GamesTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "GamesTableViewCell")
        self.tblVw.rowHeight = UITableView.automaticDimension
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setlanguage()
        self.call_GetMyGame_Api()
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetButtonColors()
        self.vwMyGames.backgroundColor = UIColor(named: "app_color")
        self.btnMyGames.setTitleColor(.white, for: .normal)
        isJoinedGames = false
    }
    
    func setlanguage(){
        self.lblGamesHeading.text = "Games".localized()
        self.btnMyGames.setTitle("My Games".localized(), for: .normal)
        self.btnJoinedGames.setTitle("Joined Games".localized(), for: .normal)
    }
    
    @IBAction func btnOnMyGames(_ sender: Any) {
        resetButtonColors()
        self.vwMyGames.backgroundColor = UIColor(named: "app_color")
        self.btnMyGames.setTitleColor(.white, for: .normal)
        isJoinedGames = false
        self.call_GetMyGame_Api()
    }
    
    @IBAction func btnOnJoinedGames(_ sender: Any) {
        resetButtonColors()
        self.vwJoinedGames.backgroundColor = UIColor(named: "app_color")
        self.btnJoinedGames.setTitleColor(.white, for: .normal)
        isJoinedGames = true
        self.call_GetMyGame_Api()
    }
    
    func resetButtonColors(){
        self.btnMyGames.setTitleColor(.black, for: .normal)
        self.btnJoinedGames.setTitleColor(.black, for: .normal)
        self.vwMyGames.backgroundColor = .white
        self.vwJoinedGames.backgroundColor = .white
        
    }
}

extension GamesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMyGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamesTableViewCell")as! GamesTableViewCell
        
        let obj = self.arrMyGames[indexPath.row]
        
        if isJoinedGames == true {
            cell.lblCategory.text = "\(obj.creator_name ?? "") (\(obj.category_name ?? ""))"
        }else{
            cell.lblCategory.text = obj.category_name
        }
       
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
        if self.isJoinedGames == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController")as! GameDetailViewController
            vc.objGameData = self.arrMyGames[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyGamesViewController")as! MyGamesViewController
            vc.objGameData = self.arrMyGames[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}


extension GamesViewController {
    
    func call_GetMyGame_Api(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dictParam = [String:Any]()
        
        if self.isJoinedGames == true{
            dictParam = ["player_id":objAppShareData.UserDetail.strUserId!]as [String:Any]
        }else{
            dictParam = ["user_id":objAppShareData.UserDetail.strUserId!]as [String:Any]
        }
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetGame, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrMyGames.removeAll()
                    for data in user_details{
                        let obj = GetGameModel.init(from: data)
                        self.arrMyGames.append(obj)
                    }
                    self.tblVw.reloadData()
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.arrMyGames.removeAll()
                    self.tblVw.reloadData()
                    if msgg == "games not Available"{
                        objAlert.showAlert(message: "No Games Available".localized(), title: "", controller: self)
                    }else{
                        objAlert.showAlert(message: msgg, title: "", controller: self)
                    }
                   
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
