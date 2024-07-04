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
    @IBOutlet weak var cvPlayers: UICollectionView!
    @IBOutlet weak var btnRequestJoine: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDateHeading: UILabel!
    @IBOutlet weak var lblTimeHeading: UILabel!
    @IBOutlet weak var lblLocationHeading: UILabel!
    
    var arrMyGamesPlayers = [GamePlayersModel]()
    var objGameData : GetGameModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.call_GetMyGame_Api(strGame_id: objGameData?.game_id ?? "")
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "GameDetailPlayersCollectionViewCell", bundle: nil)
        self.cvPlayers.register(nib, forCellWithReuseIdentifier: "GameDetailPlayersCollectionViewCell")
        
        let imageUrl  = objGameData?.category_image
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            self.imgVwCategory.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user 1"))
        }else{
            self.imgVwCategory.image = #imageLiteral(resourceName: "user 1")
        }
        self.lblCategoryName.text = objGameData?.creator_name
        self.lblDate.text = objGameData?.date
        self.lblTime.text = objGameData?.time
        self.lblLocation.text = objGameData?.location
        
        let creatorImageUrl  = objGameData?.creator_image
        if creatorImageUrl != "" {
            let url = URL(string: creatorImageUrl ?? "")
            self.imgVwUserPlayer.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user 1"))
        }else{
            self.imgVwUserPlayer.image = #imageLiteral(resourceName: "user 1")
        }
        
        let categoryImageUrl  = objGameData?.category_icon
        if categoryImageUrl != "" {
            let url = URL(string: categoryImageUrl ?? "")
            self.imgVwGameImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user 1"))
        }else{
            self.imgVwGameImage.image = #imageLiteral(resourceName: "user 1")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLanguage()
    }
    
    func setLanguage(){
        self.lblHeading.text = "Game Detail".localized()
        self.lblDateHeading.text = "Date -".localized()
        self.lblTimeHeading.text = "Time -".localized()
        self.lblLocationHeading.text = "Location -".localized()
        self.btnRequestJoine.setTitle("Request For Join".localized(), for: .normal)
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnrequestToJoine(_ sender: Any) {
        self.call_RequestToJoineGame_Api(strGame_id: self.objGameData?.game_id ?? "")
    }
}

extension GameDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrMyGamesPlayers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameDetailPlayersCollectionViewCell", for: indexPath)as! GameDetailPlayersCollectionViewCell
        
        let obj = self.arrMyGamesPlayers[indexPath.row]
        
        cell.lblName.text = obj.creator_name
        
        let categoryImageUrl  = obj.creator_image
        if categoryImageUrl != "" {
            let url = URL(string: categoryImageUrl ?? "")
            cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user 1"))
        }else{
            cell.imgVw.image = #imageLiteral(resourceName: "user 1")
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        print(totalSpace)
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size)
    }
    
}


extension GameDetailViewController {
    
    func call_GetMyGame_Api(strGame_id:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["game_id":strGame_id,
                         "approved":""]as [String:Any]
#if DEBUG
        print(dicrParam)
#endif
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetGamePlayers, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    for data in user_details{
                        let obj = GamePlayersModel.init(from: data)
                            self.arrMyGamesPlayers.append(obj)
                    }
                    
                    let requiredPlayersCount = Int(self.objGameData?.number_of_players ?? "0")
                    if self.arrMyGamesPlayers.count < requiredPlayersCount ?? 0 {
                        let remainingPlayersCount = (requiredPlayersCount ?? 0) - self.arrMyGamesPlayers.count
                        // Add remaining players with names like "player 1", "player 2", etc.
                        for i in 1...remainingPlayersCount {
                            var playernumber = self.arrMyGamesPlayers.count
                            playernumber = playernumber + 1
                            let newPlayer = GamePlayersModel.init(from: ["creator_name":"Player \(playernumber)"])
                            self.arrMyGamesPlayers.append(newPlayer)
                        }
                    }

                    self.cvPlayers.reloadData()
                    
                    let userExists = self.arrMyGamesPlayers.contains { user in
                        return user.user_id == objAppShareData.UserDetail.strUserId
                    }
                    
                    if userExists{
                        self.btnRequestJoine.isHidden = true
                    }else{
                        self.btnRequestJoine.isHidden = false
                    }
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.btnRequestJoine.isHidden = false
                    let requiredPlayersCount = Int(self.objGameData?.number_of_players ?? "0")
                    
                    if self.arrMyGamesPlayers.count < requiredPlayersCount ?? 0 {
                        let remainingPlayersCount = (requiredPlayersCount ?? 0) - self.arrMyGamesPlayers.count
                        
                        // Add remaining players with names like "player 1", "player 2", etc.
                        for i in 1...remainingPlayersCount {
                            
                            var playernumber = self.arrMyGamesPlayers.count
                            playernumber = playernumber + 1
                            
                            let newPlayer = GamePlayersModel.init(from: ["creator_name":"Player \(playernumber)"])
                            self.arrMyGamesPlayers.append(newPlayer)
                        }
                    }
                    
                    self.cvPlayers.reloadData()
                    
                    // objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
            
            
        } failure: { (Error) in
            //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //Request To Join Game
    
    func call_RequestToJoineGame_Api(strGame_id:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["game_id":strGame_id,
                         "user_id":objAppShareData.UserDetail.strUserId!]as [String:Any]
#if DEBUG
        print(dicrParam)
#endif
        objWebServiceManager.requestPost(strURL: WsUrl.url_RequestJoineGame, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK".localized(), title: "", message: "Join Request Sent Successfully".localized(), controller: self) {
                        self.onBackPressed()
                    }
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    
                    // objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
            
            
        } failure: { (Error) in
            //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
