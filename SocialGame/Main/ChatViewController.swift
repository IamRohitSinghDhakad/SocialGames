//
//  ChatViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 13/02/24.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lblChatHeading: UILabel!
    
    
    var arrUserList = [StoreModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ChatListTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "ChatListTableViewCell")
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblChatHeading.text = "Chat".localized()
        self.call_GetUserList_Api()
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
    }
}

extension ChatViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell")as! ChatListTableViewCell
        
        let obj = self.arrUserList[indexPath.row]
        let imageUrl  = obj.sender_image
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user 1"))
        }else{
            cell.imgVwUser.image = #imageLiteral(resourceName: "user 1")
        }
        cell.lblUserName.text = obj.sender_name
        cell.lblLastMessage.text = obj.last_message
        cell.lblTimeAgo.text = obj.time_ago
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController")as! ChatDetailViewController
        vc.strReceiverId = self.arrUserList[indexPath.row].receiver_id ?? ""
        vc.strSenderId = self.arrUserList[indexPath.row].sender_id ?? ""
        vc.strProductId = self.arrUserList[indexPath.row].product_id ?? ""
        vc.strUsername = self.arrUserList[indexPath.row].sender_name ?? ""
        vc.isBlocked = self.arrUserList[indexPath.row].strBlocked
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension ChatViewController{
    
    func call_GetUserList_Api(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dictParam = [String:Any]()
        dictParam = ["user_id":objAppShareData.UserDetail.strUserId!]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetConversation, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrUserList.removeAll()
                    for data in user_details{
                        let obj = StoreModel.init(from: data)
                        self.arrUserList.append(obj)
                    }
                    self.tblVw.reloadData()
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.arrUserList.removeAll()
                    self.tblVw.reloadData()
                    objAlert.showAlert(message: "Chat Histry Not Found".localized(), title: "", controller: self)
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
