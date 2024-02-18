//
//  StoreModel.swift
//  MedicisPizza
//
//  Created by Rohit SIngh Dhakad on 25/10/23.
//

import UIKit

class StoreModel: NSObject {
    
    var strStoreName : String?
    var strStoreId : Int?
    
    init(from dictionary: [String: Any]) {
        super.init()
        if let store_name = dictionary["store_name"] as? String{
            self.strStoreName = store_name
        }
        if let store_id = dictionary["store_id"] as? Int{
            self.strStoreId = store_id
        }
    }
}

/*
 {
 "current_week_turnover" = 100;
 entrydt = "2023-10-23 18:33:10";
 "last_week_turnover" = 200;
 status = 0;
 "store_id" = 3;
 "store_name" = testing3;
 "within_budget" = 0;
 }
 */
