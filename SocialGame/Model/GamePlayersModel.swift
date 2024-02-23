//
//  GamePlayersModel.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 21/02/24.
//

import UIKit

class GamePlayersModel: NSObject {
    
  
    var approved: String?
    var creator_age: String?
    var creator_email: String?
    var creator_image: String?
    var creator_mobile: Int?
    var creator_name: String?
    var creator_type: String?
    var entrydt: String?
    var game_id: String?
    var id: String?
    var time_ago: String?
    var user_id: String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["approved"] as? Int {
            approved = "\(value)"
        }else if let value = dictionary["approved"] as? String {
            approved = value
        }
        
        if let value = dictionary["creator_age"] as? Int {
            creator_age = "\(value)"
        }else  if let value = dictionary["creator_age"] as? String {
            creator_age = value
        }
        
        if let value = dictionary["creator_email"] as? String {
            creator_email = value
        }
        
        if let value = dictionary["creator_image"] as? String {
            creator_image = value
        }
        
        if let value = dictionary["creator_mobile"] as? Int {
            creator_mobile = value
        }
        
        if let value = dictionary["creator_name"] as? String {
            creator_name = value
        }
        
        if let value = dictionary["creator_type"] as? String {
            creator_type = value
        }
        
        if let value = dictionary["entrydt"] as? String {
            entrydt = value
        }
        
        if let value = dictionary["game_id"] as? String {
            game_id = value
        } else if let value = dictionary["game_id"] as? Int {
            game_id = "\(value)"
        }
        
        if let value = dictionary["id"] as? String {
            id = value
        } else if let value = dictionary["id"] as? Int {
            id = "\(value)"
        }
        
        if let value = dictionary["time_ago"] as? String {
            time_ago = value
        }
        
        if let value = dictionary["user_id"] as? String {
            user_id = value
        } else if let value = dictionary["user_id"] as? Int {
            user_id = "\(value)"
        }
    }
    
}
