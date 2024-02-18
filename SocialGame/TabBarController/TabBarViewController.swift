//
//  TabBarViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 13/02/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowRadius = 2
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.3
    }
    
/*
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 guard let items = tabBar.items else { return }
 
 switch objAppShareData.UserDetail.type {
 case "Mommy":
 items[0].title = "Home".localized()
 items[1].title = "History".localized()
 items[2].title = "Profile".localized()
 items[3].title = "Settings".localized()
 case "BabySitter":
 items[0].title = "Home".localized()
 items[1].title = "History".localized()
 items[2].title = "Profile".localized()
 items[3].title = "Settings".localized()
 default:
 break
 }
 
 
 }
 */
}
