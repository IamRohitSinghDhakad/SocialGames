//
//  MyGamesListTableViewCell.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 17/02/24.
//

import UIKit

class MyGamesListTableViewCell: UITableViewCell {

    @IBOutlet weak var vwOuter: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAgeHeading: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var vwContaineChat: UIView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var vwContaineAccept: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.vwOuter.viewShadowHeader()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
