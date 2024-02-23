//
//  GetGameModel.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 21/02/24.
//

import UIKit

class GetGameModel: NSObject {
    
    var category_icon: String?
    var category_id: String?
    var category_image: String?
    var category_name: String?
    var creator_email: String?
    var creator_image: String?
    var creator_mobile: String?
    var creator_name: String?
    var creator_type: String?
    var date: String?
    var entrydt: String?
    var file: String?
    var game_icon: String?
    var game_id: String?
    var game_image: String?
    var game_name: String?
    var isFavorite: Int?
    var isRequested: String?
    var lat: String?
    var lng: String?
    var location: String?
    var no_of_players_in_no_of_players: Int?
    var number_of_players: String?
    var number_of_teams: Int?
    var status: Int?
    var time: String?
    var time_ago: String?
    var user_id: String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["category_icon"] as? String {
            category_icon = value
        }
        
        if let value = dictionary["category_id"] as? String {
            category_id = value
        } else if let value = dictionary["category_id"] as? Int {
            category_id = "\(value)"
        }
        
        if let value = dictionary["category_image"] as? String {
            category_image = value
        }
        
        if let value = dictionary["category_name"] as? String {
            category_name = value
        }
        
        if let value = dictionary["creator_email"] as? String {
            creator_email = value
        }
        
        if let value = dictionary["creator_image"] as? String {
            creator_image = value
        }
        
        if let value = dictionary["creator_mobile"] as? String {
            creator_mobile = value
        }
        
        if let value = dictionary["creator_name"] as? String {
            creator_name = value
        }
        
        if let value = dictionary["creator_type"] as? String {
            creator_type = value
        }
        
        if let value = dictionary["date"] as? String {
            date = value
        }
        
        if let value = dictionary["entrydt"] as? String {
            entrydt = value
        }
        
        if let value = dictionary["file"] as? String {
            file = value
        }
        
        if let value = dictionary["game_icon"] as? String {
            game_icon = value
        }
        
        if let value = dictionary["game_id"] as? String {
            game_id = value
        } else if let value = dictionary["game_id"] as? Int {
            game_id = "\(value)"
        }
        
        if let value = dictionary["game_image"] as? String {
            game_image = value
        }
        
        if let value = dictionary["game_name"] as? String {
            game_name = value
        }
        
        if let value = dictionary["isFavorite"] as? Int {
            isFavorite = value
        }
        
        if let value = dictionary["isRequested"] as? Int {
            isRequested = "\(value)"
        }else if let value = dictionary["isRequested"] as? String {
            isRequested = value
        }
        
        if let value = dictionary["lat"] as? String {
            lat = value
        }
        
        if let value = dictionary["lng"] as? String {
            lng = value
        }
        
        if let value = dictionary["location"] as? String {
            location = value
        }
        
        if let value = dictionary["no_of_players_in_no_of_players"] as? Int {
            no_of_players_in_no_of_players = value
        }
        
        if let value = dictionary["number_of_players"] as? String {
            number_of_players = value
        }
        
        if let value = dictionary["number_of_teams"] as? Int {
            number_of_teams = value
        }
        
        if let value = dictionary["status"] as? Int {
            status = value
        }
        
        if let value = dictionary["time"] as? String {
            time = value
        }
        
        if let value = dictionary["time_ago"] as? String {
            time_ago = value
        }
        
        if let value = dictionary["user_id"] as? String {
            user_id = value
        }
    }
}
