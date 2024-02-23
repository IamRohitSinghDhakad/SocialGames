//
//  UserModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 25/04/21.
//

import UIKit

class UserModel: NSObject {
    
    var straAuthToken : String = ""
    var aadhar: String?
    var address: String?
    var approved: String?
    var dob: String?
    var email: String?
    var emailVerified: String?
    var mobile: String?
    var mobileVerified: String?
    var name: String?
    var experience_in_year: String?
    var nationality: String?
    var password: String?
    var registerId: String?
    var no_of_kids: String?
    var socialType: String?
    var noncriminal_certificate_image: String?
    var passport_image: String?
    var status: String?
    var isFollowed: String?
    var type: String?
    var strUserId: String?
    var userImage: String?
    var firstName : String?
    var lastName : String?
    var age : String?
    var gender : String?
    var availability : String?
    var price_per_hour : String?
    var services: String?
    var rating:Double?
    var myRating : String?
    var category_id : String?
    var strFollowers : String?
    var strFollowing : String?

    
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let auth_token = dictionary["device_id"] as? String{
            self.straAuthToken = auth_token
            UserDefaults.standard.setValue(auth_token, forKey: objAppShareData.UserDetail.straAuthToken)
        }
        
        if let value = dictionary["user_id"] as? String {
            strUserId = value
            UserDefaults.standard.setValue(strUserId, forKey: objAppShareData.UserDetail.strUserId ?? "")
        }else if let value = dictionary["user_id"] as? Int {
            strUserId = "\(value)"
            UserDefaults.standard.setValue(strUserId, forKey: objAppShareData.UserDetail.strUserId ?? "")
        }
        
        if let value = dictionary["category_id"] as? String {
            category_id = value
        }else if let value = dictionary["category_id"] as? Int {
            category_id = "\(value)"
        }
        
        if let services = dictionary["services"] as? String {
            self.services = services
        }
        
        if let value = dictionary["age"] as? String {
            self.age = value
        }
        
        if let myRating = dictionary["rating"] as? String {
            self.myRating = myRating
        }
        
        
        
        if let value = dictionary["rating"] as? Double {
            self.rating = value
        }else if let value = dictionary["rating"] as? String {
            self.rating = Double(value)
        }else if let value = dictionary["rating"] as? Int {
            self.rating = Double(value)
        }else if let value = dictionary["rating"] as? Float {
            self.rating = Double(value)
        }
        
        
        if let value = dictionary["availability"] as? String {
            self.availability = value
        }
        
        if let value = dictionary["price_per_hour"] as? String {
            self.price_per_hour = value
        }
        
        
        
        if let value = dictionary["gender"] as? String {
            self.gender = value
        }
        
        if let value = dictionary["address"] as? String {
            address = value
        }
        if let value = dictionary["approved"] as? String {
            approved = value
        }
        
        if let value = dictionary["dob"] as? String {
            dob = value
        }
        if let value = dictionary["email"] as? String {
            email = value
        }
        if let value = dictionary["email_verified"] as? String {
            emailVerified = value
        }
        if let value = dictionary["mobile"] as? String {
            mobile = value
        }
        if let value = dictionary["name"] as? String {
            name = value
        }
        if let value = dictionary["experience_in_year"] as? String {
            experience_in_year = value
        }
        if let value = dictionary["nationality"] as? String {
            nationality = value
        }
        if let value = dictionary["password"] as? String {
            password = value
        }
        if let value = dictionary["register_id"] as? String {
            registerId = value
        }
        if let value = dictionary["no_of_kids"] as? String {
            no_of_kids = value
        }
        if let value = dictionary["social_type"] as? String {
            socialType = value
        }
        if let value = dictionary["noncriminal_certificate_image"] as? String {
            noncriminal_certificate_image = value
        }
        if let value = dictionary["passport_image"] as? String {
            passport_image = value
        }
        if let value = dictionary["status"] as? String {
            status = value
        }
        if let value = dictionary["isFollowed"] as? String {
            isFollowed = value
        }else  if let value = dictionary["isFollowed"] as? Int {
            isFollowed = "\(value)"
        }
        
        if let value = dictionary["type"] as? String {
            type = value
        }
    
        if let value = dictionary["user_image"] as? String {
            userImage = value
        }
        if let first_name = dictionary["first_name"] as? String {
            self.firstName = first_name
        }
        
        if let last_name = dictionary["last_name"] as? String {
            self.lastName = last_name
        }
        
        if let value = dictionary["followers"] as? String {
            self.strFollowers = value
        }else if let value = dictionary["followers"] as? Int {
            self.strFollowers = String(value)
        }
        
        if let value = dictionary["followings"] as? String {
            self.strFollowing = value
        }else if let value = dictionary["followings"] as? Int {
            self.strFollowing = String(value)
        }
    }
    
}
