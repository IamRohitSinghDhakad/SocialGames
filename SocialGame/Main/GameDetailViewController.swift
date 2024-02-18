//
//  GameDetailViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 17/02/24.
//

import UIKit

class GameDetailViewController: UIViewController {

    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var imgVwCategory: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgVwUserPlayer: UIImageView!
    @IBOutlet weak var imgVwGameImage: UIImageView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var btnRequestJoine: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "GameDetailTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "GameDetailTableViewCell")
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnrequestToJoine(_ sender: Any) {
        
    }
}

extension GameDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameDetailTableViewCell")as! GameDetailTableViewCell
        
        
        return cell
    }
    
}

