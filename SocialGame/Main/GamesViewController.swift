//
//  GamesViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 13/02/24.
//

import UIKit

class GamesViewController: UIViewController {

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tblVw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "GamesTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "GamesTableViewCell")
        
        self.tblVw.rowHeight = UITableView.automaticDimension
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
    }
    
    @IBAction func btnOnMyGames(_ sender: Any) {
        
    }
    
    @IBAction func btnOnJoinedGames(_ sender: Any) {
        
    }
}

extension GamesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamesTableViewCell")as! GamesTableViewCell
        
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVc(viewConterlerId: "MyGamesViewController") 
    }
    
    
}
