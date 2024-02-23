//
//  GameDetailPlayersCollectionViewCell.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 22/02/24.
//

import UIKit

class GameDetailPlayersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.imgVw.cornerRadius = self.imgVw.frame.height / 2
            self.imgVw.clipsToBounds = true
        }
    }

}
