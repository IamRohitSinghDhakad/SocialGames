//
//  HomeViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 13/02/24.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var cvCategories: UICollectionView!
    
    var arrCategory = [CategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        call_GetCategory_Api()
        let nib = UINib(nibName: "CategoriesCell", bundle: nil)
        self.cvCategories.register(nib, forCellWithReuseIdentifier: "CategoriesCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.vwHeader.setCornerRadiusIndiviualCorners(radius: 30.0, corners: [.bottomLeft, .bottomRight])
        }
    }
    
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath)as! CategoriesCell
        
        let obj = self.arrCategory[indexPath.row]
        
        cell.lblTitle.text = obj.category_name
        let imageUrl  = obj.category_image
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo_one"))
        }else{
            cell.imgVw.image = #imageLiteral(resourceName: "logo_one")
        }
        
        return cell
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 3
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        print(totalSpace)
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size + 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryListViewController")as! CategoryListViewController
        vc.categoryId = "\(self.arrCategory[indexPath.row].category_id ?? "")"
        vc.categoryName = self.arrCategory[indexPath.row].category_name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController {
    
    func call_GetCategory_Api(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":objAppShareData.UserDetail.strUserId!]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetCategory, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    for data in user_details{
                        let obj = CategoryModel.init(from: data)
                        self.arrCategory.append(obj)
                    }
                    self.cvCategories.reloadData()
                
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
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
