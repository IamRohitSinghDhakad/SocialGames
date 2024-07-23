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
    var currentOptionsCell: ChatListTableViewCell?
    
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
        
        // Add long press gesture to the cell
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        cell.addGestureRecognizer(longPressGesture)
        
        // Add action for cancel button
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside)
        
//        // Add action for Report button
//        cell.btnReportUser.tag = indexPath.row
//        cell.btnReportUser.addTarget(self, action: #selector(reportButtonClicked(_:)), for: .touchUpInside)
//        
        // Add action for Report button
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteButtonClicked(_:)), for: .touchUpInside)
        
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
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
           if gesture.state == .began {
               let touchPoint = gesture.location(in: self.tblVw)
               if let indexPath = tblVw.indexPathForRow(at: touchPoint) {
                   let cell = tblVw.cellForRow(at: indexPath) as! ChatListTableViewCell
                   // Hide the currently visible options view if any
                   currentOptionsCell?.hideOptions()
                   // Show the new options view
                   cell.showOptions()
                   // Update the currently visible options cell
                   currentOptionsCell = cell
               }
           }
       }
       
       @objc func cancelButtonClicked(_ sender: UIButton) {
           if let cell = sender.getParentTableViewCell() as? ChatListTableViewCell {
               cell.hideOptions()
               // Clear the reference if the current cell's options view is being hidden
               if currentOptionsCell == cell {
                   currentOptionsCell = nil
               }
           }
       }
    
    @objc func deleteButtonClicked(_ sender: UIButton) {
        if let cell = sender.getParentTableViewCell() as? ChatListTableViewCell {
            cell.hideOptions()
            // Clear the reference if the current cell's options view is being hidden
            if currentOptionsCell == cell {
                currentOptionsCell = nil
            }
        }
        objAlert.showAlertCallBack(alertLeftBtn: "Yes".localized(), alertRightBtn: "No".localized(), title: "", message: "Are you sure you want to delete chat history with this user ?".localized(), controller: self) {
            self.call_ClearConversation(strSenderID: self.arrUserList[sender.tag].sender_id ?? "", strReceiverID: self.arrUserList[sender.tag].receiver_id ?? "", strProductID: self.arrUserList[sender.tag].product_id ?? "")
        }
        
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
    
    
    //MARK:- Delete Singhe Message
    func call_ClearConversation(strSenderID:String, strReceiverID:String,strProductID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["sender_id":strSenderID,
                         "receiver_id":strReceiverID,
                         "product_id":strProductID,
                         "delete_conversation":"1"]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_clearConversation, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                self.call_GetUserList_Api()
               
                
            }else{
                objWebServiceManager.hideIndicator()
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
}

extension UIView {
    func getParentTableViewCell() -> UITableViewCell? {
        var view = self
        while let superview = view.superview {
            if let cell = superview as? UITableViewCell {
                return cell
            }
            view = superview
        }
        return nil
    }
}
