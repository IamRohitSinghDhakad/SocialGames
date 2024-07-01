//
//  MyGamesViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 17/02/24.
//

import UIKit

class MyGamesViewController: UIViewController {

    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var imgVwCategory: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblDateHeading: UILabel!
    @IBOutlet weak var lblTimeHeading: UILabel!
    @IBOutlet weak var lblLocationHeading: UILabel!
    @IBOutlet weak var lblAllReq: UILabel!
    
    var arrMyGamesPlayers = [GamePlayersModel]()
    var objGameData : GetGameModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        call_GetMyGame_Api(strGame_id: self.objGameData?.game_id ?? "")
        let nib = UINib(nibName: "MyGamesListTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "MyGamesListTableViewCell")
        
        let imageUrl  = objGameData?.category_image
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            self.imgVwCategory.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user 1"))
        }else{
            self.imgVwCategory.image = #imageLiteral(resourceName: "user 1")
        }
        self.lblDate.text = objGameData?.date
        self.lblTime.text = objGameData?.time
        self.lblLocation.text = objGameData?.location
        self.lblHeaderTitle.text = objGameData?.category_name?.localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblDateHeading.text = "Date -".localized()
        self.lblTimeHeading.text = "Time -".localized()
        self.lblLocationHeading.text = "Location -".localized()
        self.lblAllReq.text = "All Requests".localized()
    }
    
    
    

    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
}

extension MyGamesViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMyGamesPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGamesListTableViewCell")as! MyGamesListTableViewCell
        
        let obj = self.arrMyGamesPlayers[indexPath.row]
        let imageUrl  = obj.creator_image
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user 1"))
        }else{
            cell.imgVwUser.image = #imageLiteral(resourceName: "user 1")
        }
        cell.lblAge.text = "\(obj.creator_age ?? "")yr"
        cell.lblUserName.text = obj.creator_name
        
        if obj.approved == "1"{
            cell.btnAccept.setTitle("Accepted".localized(), for: .normal)
            cell.btnAccept.backgroundColor = UIColor(named: "app_color")
            cell.btnAccept.setTitleColor(.white, for: .normal)
            cell.btnAccept.cornerRadius = 8
        }else{
            cell.btnAccept.setTitle("Accept".localized(), for: .normal)
            cell.btnAccept.backgroundColor = .clear
            cell.btnAccept.setTitleColor(.black, for: .normal)
            cell.btnAccept.cornerRadius = 0
            cell.btnAccept.tag = indexPath.row
            cell.btnAccept.addTarget(self, action: #selector(btnAcceptAction(sender:)), for: .touchUpInside)
        }
        
        cell.btnChat.tag = indexPath.row
        cell.btnChat.addTarget(self, action: #selector(btnChatAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btnAcceptAction(sender: UIButton){
        let buttonTag = sender.tag
        
        print(buttonTag)
    }
    
    @objc func btnChatAction(sender: UIButton){
        let buttonTag = sender.tag
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController")as! ChatDetailViewController
        vc.strReceiverId = objAppShareData.UserDetail.strUserId ?? ""
        vc.strSenderId = self.arrMyGamesPlayers[buttonTag].user_id ?? ""
        vc.strProductId = self.arrMyGamesPlayers[buttonTag].game_id ?? ""
        vc.strUsername = self.arrMyGamesPlayers[buttonTag].creator_name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileViewController")as! OtherUserProfileViewController
        vc.userID = self.arrMyGamesPlayers[indexPath.row].user_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension MyGamesViewController{
    
    func call_GetMyGame_Api(strGame_id:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["game_id":strGame_id,
                         "approved":""]as [String:Any]
        #if DEBUG
        print(dicrParam)
        #endif
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetGamePlayers, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    for data in user_details{
                         let obj = GamePlayersModel.init(from: data)
                           self.arrMyGamesPlayers.append(obj)
                    }
                     self.tblVw.reloadData()
                    self.tblVw.displayBackgroundText(text: "")
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    
                    self.tblVw.displayBackgroundText(text: "No Requests Comes Yet".localized())
                    self.tblVw.reloadData()
                   // objAlert.showAlert(message: msgg, title: "", controller: self)
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
