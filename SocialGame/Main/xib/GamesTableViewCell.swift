//
//  GamesTableViewCell.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 15/02/24.
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    @IBOutlet weak var vwOuterImage: UIView!
    @IBOutlet weak var vwOuter: UIView!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDateHeading: UILabel!
    @IBOutlet weak var lblTimeHeading: UILabel!
    @IBOutlet weak var lblLocationHeading: UILabel!
    
    
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
