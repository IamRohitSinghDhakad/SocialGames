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
    
    var isComingfrom = ""
    
    let arrLanguages = ["English", "Turkish", "Russian", "Spanish", "French", "German", "Italian", "Arabic", "Chinese", "Japanese"]
    let languageCodes = ["en", "tr", "ru", "es", "fr", "de", "it", "ar", "zh", "ja"]
    
    var selectedLanguageIndex: Int? // Store the index of the selected language
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblSelectLanguage.text = "Select Language".localized()
        
        let nib = UINib(nibName: "SelectLanguageTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "SelectLanguageTableViewCell")
        
        tblVw.delegate = self
        tblVw.dataSource = self
        
        // Load the current language setting
        loadCurrentLanguage()
    }
    
    @IBAction func btnOnOK(_ sender: Any) {
        if let index = selectedLanguageIndex {
            let selectedLanguageCode = languageCodes[index]
            let selectedLanguage = arrLanguages[index]
            setLanguage(languageCode: selectedLanguageCode, language: selectedLanguage)
        }
        // Comment out this line if you don't want to navigate immediately after changing the language
        // pushVc(viewConterlerId: "LoginViewController")
    }
}

extension SelectLanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLanguageTableViewCell") as! SelectLanguageTableViewCell
        
        cell.lblTitle.text = arrLanguages[indexPath.row]
        
        // Show a checkmark for the selected language
        if indexPath.row == selectedLanguageIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguageIndex = indexPath.row
        tableView.reloadData() // Refresh the table to show the checkmark
    }
    
    //    func changeLanguage(to languageCode: String) {
    //        LocalizationSystem.sharedInstance.setLanguage(languageCode: languageCode)
    //        objAppShareData.currentLanguage = languageCode
    //
    //        // Update UI direction based on the language
    //        if languageCode == "ar" {
    //            UIView.appearance().semanticContentAttribute = .forceRightToLeft
    //        } else {
    //            UIView.appearance().semanticContentAttribute = .forceLeftToRight
    //        }
    //
    //        // Save the language setting
    //        UserDefaults.standard.set(languageCode, forKey: "appLanguage")
    //        UserDefaults.standard.synchronize()
    //
    //        // Restart the app by resetting the root view controller
    //        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
    //            if let window = windowScene.windows.first {
    //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //                window.rootViewController = storyboard.instantiateInitialViewController()
    //                window.makeKeyAndVisible()
    //            }
    //        }
    //    }
    
    private func loadCurrentLanguage() {
        if let currentLanguageCode = UserDefaults.standard.string(forKey: "appLanguage"),
           let index = languageCodes.firstIndex(of: currentLanguageCode) {
            selectedLanguageIndex = index
            tblVw.reloadData()
        }
    }
    
    private func setLanguage(languageCode: String, language: String) {
        let alert = UIAlertController(title: nil, message: "Please reopen the app to apply the language change.".localized(), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Exit and Reopen".localized(), style: .default, handler: { [weak self](_) in
            // Update app's language with the language code
            UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            self?.scheduleReopenNotification(language: language)
        }))
        // Show change language alert to user
        self.present(alert, animated: true, completion: nil)
    }
    
    private func scheduleReopenNotification(language: String) {
            let content = UNMutableNotificationContent()
            content.title = "Language changed to \(language)"
            content.body = "Tap to reopen the application"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
            let identifier = "languageChangeNotification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
            
            // Exit the app to apply the language change
            exit(EXIT_SUCCESS)
        }
    
}
