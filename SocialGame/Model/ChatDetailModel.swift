//
//  ChatDetailModel.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 18/02/24.
//

import UIKit

class ChatDetailModel:NSObject {
    
    var strOpponentChatMessage : String = ""
    var strOpponentChatTime : String = ""
    var strReceiverID   : String = ""
    var strImageUrl   : String = ""
    var strMsgIDForDelete  : String = ""
    var strSenderId : String = ""
    var strChatTime   : String = ""
    var strType   : String = ""
 
    
    
    init(dict : [String:Any]) {
        
        if let receiver_id = dict["receiver_id"] as? String{
            self.strReceiverID = receiver_id
        }else  if let receiver_id = dict["receiver_id"] as? String{
            self.strReceiverID = receiver_id
        }
        
        if let sender_id = dict["sender_id"] as? String{
            self.strSenderId = sender_id
        }else  if let sender_id = dict["sender_id"] as? String{
            self.strSenderId = sender_id
        }
        
        if let id = dict["chat_id"] as? String{
            self.strMsgIDForDelete = id
        }else  if let id = dict["chat_id"] as? String{
            self.strMsgIDForDelete = id
        }
        
        if let chat_image = dict["chat_image"] as? String{
            self.strImageUrl = chat_image.trim()
        }
        
        
        if let chat_Time = dict["created_at"]as? String{
            self.strChatTime = chat_Time
        }
        
        if let type = dict["type"]as? String{
            self.strType = type
        }
        
    
        if let chat_message = dict["chat_message"] as? String{
            self.strOpponentChatMessage = chat_message.decodeEmoji
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strOpponentChatTime = time_ago
        }
        
        
    }
    
}
