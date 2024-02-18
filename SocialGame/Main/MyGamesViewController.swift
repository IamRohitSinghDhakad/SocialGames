//
//  MyGamesViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 17/02/24.
//

import UIKit

class MyGamesViewController: UIViewController {

    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var imgVwCategory: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "MyGamesListTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "MyGamesListTableViewCell")
    }
    

    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
}

extension MyGamesViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGamesListTableViewCell")as! MyGamesListTableViewCell
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVc(viewConterlerId: "OtherUserProfileViewController")
    }
    
    
    
}
