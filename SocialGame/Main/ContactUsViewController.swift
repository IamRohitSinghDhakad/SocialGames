//
//  ContactUsViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 23/02/24.
//

import UIKit

class ContactUsViewController: UIViewController,UINavigationControllerDelegate {

    @IBOutlet weak var txtVwMsg: RDTextView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var imgvw: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnAddImage(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        
        self.tfTitle.text = self.tfTitle.text?.trim()
        self.txtVwMsg.text = self.txtVwMsg.text?.trim()
        
        if tfTitle.text == ""{
            objAlert.showAlert(message: "Please enter problem", controller: self)
        }else  if txtVwMsg.text == ""{
            objAlert.showAlert(message: "Please enter message", controller: self)
        }else{
            self.callWebserviceForContactUs()
        }
        
    }
}

// MARK:- UIImage Picker Delegate
extension ContactUsViewController: UIImagePickerControllerDelegate{
    
    func setImage(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    // Open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = .fullScreen
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            self.openGallery()
        }
    }
    
    // Open gallery
    func openGallery()
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.pickedImage = editedImage
            self.imgvw.image = self.pickedImage

            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgvw.image = pickedImage
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func cornerImage(image: UIImageView, color: UIColor ,width: CGFloat){
        image.layer.cornerRadius = image.layer.frame.size.height / 2
        image.layer.masksToBounds = false
        image.layer.borderColor = color.cgColor
        image.layer.borderWidth = width
        
    }
    
   
    
}

extension ContactUsViewController {
    
    func callWebserviceForContactUs(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var imageData = [Data]()
        var imgData : Data?
        if self.pickedImage != nil{
            imgData = (self.pickedImage?.jpegData(compressionQuality: 0.5))!
        }
        else {
            imgData = (self.imgvw.image?.jpegData(compressionQuality: 0.5))!
        }
        imageData.append(imgData!)
        
        let imageParam = ["image"]
        
        let dicrParam = [
            "user_id":objAppShareData.UserDetail.strUserId ?? "",
            "title":self.tfTitle.text!,
            "message":self.txtVwMsg.text!]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_ContactUs, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                guard let user_details  = response["result"] as? [String:Any] else{
                    return
                }
                
                objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "", message: "Submitted Succesfully", controller: self) {
                    self.onBackPressed()
                }
                
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
}
