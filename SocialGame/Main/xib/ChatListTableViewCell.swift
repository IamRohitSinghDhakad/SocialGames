//
//  ChatListTableViewCell.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 18/02/24.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLastMessage: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var vwOptions: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwOptions.isHidden = true
    }
    
    func showOptions() {
          vwOptions.isHidden = false
          vwOptions.alpha = 0.0
          UIView.animate(withDuration: 0.3) {
              self.vwOptions.alpha = 1.0
          }
      }
      
      func hideOptions() {
          UIView.animate(withDuration: 0.3, animations: {
              self.vwOptions.alpha = 0.0
          }) { _ in
              self.vwOptions.isHidden = true
          }
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
