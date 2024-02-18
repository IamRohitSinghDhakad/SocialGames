//
//  SelectLanguageViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 12/02/24.
//

import UIKit

class SelectLanguageViewController: UIViewController {
    
    @IBOutlet weak var lblSelectLanguage: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var btnOK: UIButton!
    
    let arrLanguages = ["English", "Turkish", "Russian", "Spanish", "French", "German", "Italian", "Arabic", "Chinese", "Japanese"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "SelectLanguageTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "SelectLanguageTableViewCell")
        
    }
    
    @IBAction func btnOnOK(_ sender: Any) {
        pushVc(viewConterlerId: "LoginViewController")
    }
    
}


extension SelectLanguageViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLanguageTableViewCell")as! SelectLanguageTableViewCell
        
        cell.lblTitle.text = self.arrLanguages[indexPath.row]
        
        return cell
}
    
    
}
