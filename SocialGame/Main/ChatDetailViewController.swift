//
//  ChatDetailViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 18/02/24.
//

import UIKit

class ChatDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblUserame: UILabel!
    @IBOutlet weak var tblChatList: UITableView!
    @IBOutlet var txtVwChat: RDTextView!
    @IBOutlet var hgtConsMaximum: NSLayoutConstraint!
    @IBOutlet var hgtConsMinimum: NSLayoutConstraint!
    @IBOutlet weak var vwBlocked: UIView!
    @IBOutlet weak var lblBlockMessage: UILabel!
    @IBOutlet weak var vwClearConversation: UIView!
    
    
    let txtViewCommentMaxHeight: CGFloat = 100
    let txtViewCommentMinHeight: CGFloat = 34
    var strReceiverId = ""
    var strSenderId = ""
    var strProductId = ""
    var strUsername = ""
    var isBlocked = ""
    var timer: Timer?
    var arrCount = Int()
    var initilizeFirstTimeOnly = Bool()
    
    //  var arrChatMsg = NSMutableArray()
    var arrChatMsg = [ChatDetailModel]()
    var dictPrevious = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwBlocked.isHidden = true
        self.lblUserame.text = self.strUsername
        tblChatList.delegate = self
        tblChatList.dataSource = self
        self.txtVwChat.delegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.tblChatList.addGestureRecognizer(longPress)
        
//        if self.timer == nil{
//            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
//        }else{
//            
//        }
//        print(isBlocked)
//        if self.isBlocked == "1"{
//            self.vwBlocked.isHidden = false
//        }else{
//            self.vwBlocked.isHidden = true
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
        self.call_GetProfile(strUserID: self.strSenderId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func updateTimer() {
        //example functionality
        self.call_GetChat()
    }
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func btnClearConversation(_ sender: Any) {
        objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "", message: "You want to delete the chat with \(self.strUsername) ?", controller: self) {
            self.timer?.invalidate()
            self.timer = nil
            self.call_ClearConversation(strUserID: objAppShareData.UserDetail.strUserId ?? "", strProductID: self.strProductId)
        }
    }
    
    @IBAction func btnOnBlockUser(_ sender: Any) {
        
        // Create the action sheet
        let actionSheet = UIAlertController(title: "Choose Action".localized(), message: "What would you like to do?".localized(), preferredStyle: .actionSheet)

        // Add the "Report" action
        let reportAction = UIAlertAction(title: "Report".localized(), style: .destructive) { action in
            // Handle the report action here
            print("User chose to report")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportViewController")as! ReportViewController
            vc.strUser_id = self.strSenderId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        actionSheet.addAction(reportAction)

        // Add the "Block" or "Unblock" action based on the isBlocked status
        if self.isBlocked == "true" {
            let unblockAction = UIAlertAction(title: "Unblock".localized(), style: .destructive) { action in
                // Handle the unblock action here
                print("User chose to unblock")
                // You can handle the unblocking logic here
                self.call_blockUnblockeUser(strUserID: self.strSenderId)
                // self.vwBlocked.isHidden = true
                // self.lblBlockMessage.text = "User Unblocked".localized()
            }
            actionSheet.addAction(unblockAction)
        } else {
            let blockAction = UIAlertAction(title: "Block".localized(), style: .destructive) { action in
                // Handle the block action here
                print("User chose to block")
                // You can handle the blocking logic here
                self.call_blockUnblockeUser(strUserID: self.strSenderId)
                // self.vwBlocked.isHidden = false
                // self.lblBlockMessage.text = "User Blocked".localized()
            }
            actionSheet.addAction(blockAction)
        }

        // Add the "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { action in
            // Handle the cancel action here
            print("User canceled the action")
        }
        actionSheet.addAction(cancelAction)

        // Present the action sheet
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view // to set the source of your alert if it is a popover
            popoverController.sourceRect = (sender as AnyObject).bounds // you can set the position of the popover here
        }

        self.present(actionSheet, animated: true, completion: nil)

        
        
//        // Create the action sheet
//        let actionSheet = UIAlertController(title: "Choose Action".localized(), message: "What would you like to do?".localized(), preferredStyle: .actionSheet)
//        
//        // Add the "Report" action
//        let reportAction = UIAlertAction(title: "Report".localized(), style: .destructive) { action in
//            // Handle the report action here
//            print("User chose to report")
//            // You can navigate to the report screen or show another dialog here
//            self.call_ReportUser_Api(userID: self.strSenderId)
//        }
//        
//        // Add the "Block" action
//        if self.isBlocked == "1"{
//            
//        }else{
//            
//        }
//        let blockAction = UIAlertAction(title: "Block".localized(), style: .destructive) { action in
//            // Handle the block action here
//            print("User chose to block")
//            // You can handle the blocking logic here
//            self.call_BlockUser_Api(userID: self.strSenderId)
////            self.vwBlocked.isHidden = false
////            self.lblBlockMessage.text = "User Blocked".localized()
//        }
//        
//        // Add the "Cancel" action
//        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { action in
//            // Handle the cancel action here
//            print("User canceled the action")
//        }
//        
//        // Add the actions to the action sheet
//        actionSheet.addAction(reportAction)
//        actionSheet.addAction(blockAction)
//        actionSheet.addAction(cancelAction)
//        
//        // Present the action sheet
//        if let popoverController = actionSheet.popoverPresentationController {
//            popoverController.sourceView = self.view // to set the source of your alert if it is a popover
//            popoverController.sourceRect = (sender as AnyObject).bounds // you can set the position of the popover here
//        }
//        
//        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatMsg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell
        
        
        let obj = self.arrChatMsg[indexPath.row]
        
        
    
        
        if obj.strSenderId == self.strReceiverId{
            cell.vwMyMsg.isHidden = false
            cell.lblMyMsg.text = obj.strOpponentChatMessage
            cell.lblMyMsgTime.text = obj.strOpponentChatTime
            cell.vwOpponent.isHidden = true
        }else{
            cell.lblOpponentMsg.text = obj.strOpponentChatMessage
            cell.lblopponentMsgTime.text = obj.strOpponentChatTime
            cell.vwOpponent.isHidden = false
            cell.vwMyMsg.isHidden = true
        }
        //    }
        
        cell.lblOpponentMsg.text = obj.strOpponentChatMessage
        //  cell.lblopponentMsgTime.text = obj.strChatTime
        //  cell.lblMyMsgTime.text = obj.strChatTime
        
        return cell
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tblChatList)
            if let indexPath = tblChatList.indexPathForRow(at: touchPoint) {
                print(indexPath.row)
                // your code here, get the row for the indexPath or do whatever you want
                
                let id = self.arrChatMsg[indexPath.row].strSenderId
                if id == objAppShareData.UserDetail.strUserId{
                    self.openActionSheet(index: indexPath.row)
                }
            }
        }
    }
    
    
    
    func openActionSheet(index:Int){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Delete message", style: UIAlertAction.Style.default, handler: { (action) -> Void in
         //Delete Message
            
            objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "", message: "Do you want to delete this message?", controller: self) {
                let msgID = self.arrChatMsg[index].strMsgIDForDelete
                let rec_ID = self.arrChatMsg[index].strSenderId
                self.call_DeleteChatMsgSinle(strUserID: rec_ID, strMsgID: msgID)
                
            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Copy message", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //Copy Message
            UIPasteboard.general.string = self.arrChatMsg[index].strOpponentChatMessage
            objAlert.showAlert(message: "Copied text", title: "Alert", controller: self)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { (action) -> Void in
            
        }))
        self.present(actionsheet, animated: true, completion: nil)
    }

    
    func updateTableContentInset() {
        let numRows = self.tblChatList.numberOfRows(inSection: 0)
        var contentInsetTop = self.tblChatList.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tblChatList.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tblChatList.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    
    
    @IBAction func btnSendMessage(_ sender: Any) {
        if (txtVwChat.text?.isEmpty)!{
            
            self.txtVwChat.text = "."
            self.txtVwChat.text = self.txtVwChat.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            self.txtVwChat.isScrollEnabled = false
            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
            self.txtVwChat.text = ""
            
            if self.txtVwChat.text!.count > 0{
                
                self.txtVwChat.isScrollEnabled = false
                
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
            
        }else{
            
            
            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
            DispatchQueue.main.async {
                let text  = self.txtVwChat.text!//.encodeEmoji
                self.sendMessageNew(strText: text)
            }
            if self.txtVwChat.text!.count > 0{
                self.txtVwChat.isScrollEnabled = false
                
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
        }
        
    }
    
}


//MARK:- UItextViewHeightManage
extension ChatDetailViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 150
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.txtVwChat.text == "\n"{
            self.txtVwChat.resignFirstResponder()
        }
        else{
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if self.txtVwChat.contentSize.height >= self.txtViewCommentMaxHeight
        {
            self.txtVwChat.isScrollEnabled = true
        }
        else
        {
            self.txtVwChat.frame.size.height = self.txtVwChat.contentSize.height
            self.txtVwChat.isScrollEnabled = false
        }
    }
    
    
    
    func sendMessageNew(strText:String){
        self.txtVwChat.isScrollEnabled = false
        self.txtVwChat.contentSize.height = self.txtViewCommentMinHeight
        self.txtVwChat.text = self.txtVwChat.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtVwChat.text == "" {
            objAlert.showAlert(message: "Please enter some text", controller: self)
            return
        }else{
            
            self.call_SendTextMessageOnly(strText: self.txtVwChat.text!)
        }
        self.txtVwChat.text = ""
    }
    
}


extension ChatDetailViewController{
    
    // MARK:- Get Profile
    
    func call_GetProfile(strUserID: String) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
      //  objWebServiceManager.showIndicator()
        
        let parameter = ["user_id" : strUserID, "login_id" : objAppShareData.UserDetail.strUserId ?? ""] as [String:Any]
        
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { (response) in
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            objWebServiceManager.hideIndicator()
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                   print(user_details)
                    var blockStatus = ""
                    var blockedByMeStatus = ""
                    if let status = user_details["blocked"]as? String{
                        blockStatus = status
                    }else  if let status = user_details["blocked"]as? Int{
                        blockStatus = "\(status)"
                    }
                    
                    if let status = user_details["blockedByYou"]as? String{
                        blockedByMeStatus = status
                    }else  if let status = user_details["blockedByYou"]as? Int{
                        blockedByMeStatus = "\(status)"
                    }
                    
                    print(blockStatus)
                    print(blockedByMeStatus)
                    
                    if blockedByMeStatus == "1"{
                        self.vwBlocked.isHidden = false
                        self.vwClearConversation.isHidden = true
                        self.lblBlockMessage.text = "You have blocked by this user"
                        self.isBlocked = "false"
                    }else if blockStatus == "1"{
                        self.vwBlocked.isHidden = false
                        self.lblBlockMessage.text = "You blocked this user"
                        self.vwClearConversation.isHidden = true
                        self.isBlocked = "true"
                    }else{
                        self.vwBlocked.isHidden = true
                        self.isBlocked = "false"
                        self.vwClearConversation.isHidden = false
                        if self.timer == nil{
                            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                        }else{
                            
                        }
                    }
                    
                }
                else {
                    objWebServiceManager.hideIndicator()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    func call_GetChat(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        // objWebServiceManager.showIndicator()
        
        //        let receiverId = dictPrevious.GetString(forKey: "receiver_id")
        //        let senderId = dictPrevious.GetString(forKey: "sender_id")
        
        let dict = ["receiver_id":self.strReceiverId,
                    "sender_id":self.strSenderId,
                    "product_id":self.strProductId]
        
        print(dict)
        
        let url  = WsUrl.url_GetChat //+"?receiver_id=\(receiverId)&sender_id=\(senderId)" //\(dict["user_id"] ?? "")
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dict, strCustomValidation: "", showIndicator: false) { [self] (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                //                if let user_details  = response["result"] as? [[String:Any]] {
                //                    print("user_details>>>>>\(user_details)")
                //
                //                    for data in user_details{
                //                        let obj = ChatDetailModel.init(dict: data)
                //                        self.arrChatMsg.append(obj)
                //                    }
                //                 //   self.arrChatMsg = user_details.mutableCopy() as! NSMutableArray
                //                    if self.arrChatMsg.count > 0 {
                //                        self.tblChatList.displayBackgroundText(text: "")
                //                    }else{
                //                        self.tblChatList.displayBackgroundText(text: "No Chat Found")
                //                    }
                //                    self.tblChatList.reloadData()
                //                }
                
                if let arrData  = response["result"] as? [[String:Any]] {
                    var newArrayChatMessages: [ChatDetailModel] = []
                    for dict in arrData {
                        let obj = ChatDetailModel.init(dict: dict)
                        newArrayChatMessages.append(obj)
                    }
                    
                    
                    if self.arrChatMsg.count == 0 {
                        //Add initially all
                        self.arrChatMsg.removeAll()
                        self.tblChatList.reloadData()
                        
                        for i in 0..<arrData.count{
                            let dictdata = arrData[i]
                            let obj = ChatDetailModel.init(dict: dictdata)
                            self.arrChatMsg.insert(obj, at: i)
                            self.tblChatList.insertRows(at: [IndexPath(item: i, section: 0)], with: .none)
                        }
                        DispatchQueue.main.async {
                            self.tblChatList.scrollToBottom()
                        }
                        
                    }
                    else {
                        let previoudIds = self.arrChatMsg.map { $0.strMsgIDForDelete }
                        let newIds = newArrayChatMessages.map { $0.strMsgIDForDelete }
                        
                        let previoudIdsSet = Set(previoudIds)
                        let newIdsSet = Set(newIds)
                        
                        let unique = (previoudIdsSet.symmetricDifference(newIdsSet)).sorted()
                        
                        for uniqueId in unique {
                            if previoudIds.contains(uniqueId) {
                                //Remove the element
                                if let idToDelete = self.arrChatMsg.firstIndex(where: { $0.strMsgIDForDelete == uniqueId }) {
                                    self.arrChatMsg.remove(at: idToDelete)
                                    self.tblChatList.deleteRows(at: [IndexPath(item: idToDelete, section: 0)], with: .none)
                                    
                                }
                            }
                            else if newIds.contains(uniqueId) {
                                // Add new element
                                let filterObj = newArrayChatMessages.filter({ $0.strMsgIDForDelete == uniqueId })
                                if filterObj.count > 0 {
                                    let index = self.arrChatMsg.count
                                    self.arrChatMsg.insert(filterObj[0], at: index)
                                    self.tblChatList.insertRows(at: [IndexPath(item: index, section: 0)], with: .none)
                                    self.tblChatList.scrollToBottom()
                                }
                            }
                        }
                    }
                    
                    if self.initilizeFirstTimeOnly == false{
                        self.initilizeFirstTimeOnly = true
                        self.arrCount = self.arrChatMsg.count
                    }
                    
                    if self.arrCount == self.arrChatMsg.count{
                        
                    }else{
                        self.updateTableContentInset()
                    }
                    if self.arrChatMsg.count == 0{
                        self.tblChatList.displayBackgroundText(text: "No Message Found!")
                    }else{
                        self.tblChatList.displayBackgroundText(text: "")
                    }
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                self.arrChatMsg.removeAll()
                self.tblChatList.reloadData()
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    // objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    // objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:- Send CHat Message
    
    //MARK:- Send Text message Only
    
    func call_SendTextMessageOnly(strText:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        // objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["receiver_id":self.strSenderId,//Opponent ID
                         "sender_id":self.strReceiverId,//My ID
                         "product_id":self.strProductId,
                         "chat_message":strText]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_InsertChat, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if let result = response["result"]as? String{
                if result == "successful"{
                    self.initilizeFirstTimeOnly = false
                }else{
                    objAlert.showAlert(message: "Inappropriate content detected. Please modify your message.".localized(), controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                
            }
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
}

class ChatListCell:UITableViewCell {
    
    @IBOutlet weak var vwOpponent: UIView!
    @IBOutlet weak var vwMyMsg: UIView!
    @IBOutlet weak var lblOpponentMsg: UILabel!
    @IBOutlet weak var lblopponentMsgTime: UILabel!
    @IBOutlet weak var lblMyMsg: UILabel!
    @IBOutlet weak var lblMyMsgTime: UILabel!
    
}


//MARK:- Scroll to bottom
extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}


//Block user and Report User API

extension ChatDetailViewController{
    
    //MARK:- Delete Singhe Message
    func call_DeleteChatMsgSinle(strUserID:String, strMsgID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "chat_id":strMsgID]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_deleteChatSingleMessage, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                self.initilizeFirstTimeOnly = false
                //self.call_GetChatList(strUserID: strUserID, strSenderID: self.strSenderID)
                
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                   // self.tblChat.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                   // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //MARK:- Clear Conversation Message
    func call_ClearConversation(strUserID:String,strProductID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["sender_id":strSenderId,
                         "receiver_id":strUserID,
                         "product_id":strProductID]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_clearConversation, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            print(response)
            
            if (response["result"]as? Int) != nil{
                objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "History Deleted", message: "Chat History deleted", controller: self) {
                    self.onBackPressed()
                }
            }
            
            if status == MessageConstant.k_StatusCode{
                
               
                
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblChatList.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    func call_ReportUser_Api(userID: String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":userID,
                         "reported_by":objAppShareData.UserDetail.strUserId!]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_ReportUser, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if response["result"] is [[String:Any]] {
                    
                    let confirmationDialog = UIAlertController(title: "Report Submitted".localized(), message: "Thank you for helping us keep our community safe.".localized() + "\n" + "Your report has been submitted successfully. We take objectionable content very seriously and will review this report within 24 hours. If the content is found to violate our community guidelines, appropriate actions will be taken, including removing the content and ejecting the user who provided it.".localized() + "\n" + "Your vigilance helps us maintain a respectful and enjoyable environment for everyone.".localized(), preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK".localized(), style: .default) { _ in
                        // Navigate to the previous page
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    confirmationDialog.addAction(okAction)
                    self.present(confirmationDialog, animated: true, completion: nil)
                    
                    
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
    
    //MARK: Block API
    func call_blockUnblockeUser(strUserID: String) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        let parameter = ["blocked_by":objAppShareData.UserDetail.strUserId ?? "","user_id":strUserID] as [String:Any]
       // let parameter = ["blocked_by":strUserID,"user_id":objAppShareData.UserDetail.strUser_id] as [String:Any]
        
        print(parameter)
        objWebServiceManager.requestPost(strURL: WsUrl.url_BlockUser, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { (response) in
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            objWebServiceManager.hideIndicator()
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                   print(user_details)
                    
                    
                    if let unblockedStatus = user_details["unblocked"]as? Int{
                        self.vwBlocked.isHidden = true
                        self.vwClearConversation.isHidden = false
                        self.isBlocked = "false"
                        if self.timer == nil{
                            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                        }else{
                            
                        }
                    }
                    else{
                        self.isBlocked = "true"
                        self.vwBlocked.isHidden = false
                        self.vwClearConversation.isHidden = true
                        self.timer?.invalidate()
                        self.timer = nil
                    }
                    
                   // self.call_GetProfile(strUserID: objAppShareData.UserDetail.strUser_id)
                  
                  
                    
                }
                else {
                    objWebServiceManager.hideIndicator()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
}
