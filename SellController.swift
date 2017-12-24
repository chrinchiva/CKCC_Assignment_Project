//
//  SellController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/21/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SellController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var image1View: UIImageView!
    @IBOutlet weak var image2View: UIImageView!
    @IBOutlet weak var image3View: UIImageView!
    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var sellerPhoneNumberTextField: UITextField!
    @IBOutlet weak var priceOfProductTextField: UITextField!
    var imageOrder = 0
    var selectedImage:[UIImage]!
    //var imageProduct : [UIImage]!
    var imageProduct1 : UIImage!
    var imageProduct2 : UIImage!
    var imageProduct3 : UIImage!
    
    
    
    @IBOutlet weak var productCategoryTextField: UITextField!
    var product_categolary = ["Book","Phone","Computer","Shirt","Book","Phone","Computer","Shirt","Book","Phone","Computer","Other"]
    let picker = UIPickerView()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.alpha = 0.5
        imageProduct1 = UIImage(named: "default_image_select")
        imageProduct2 = UIImage(named: "default_image_select")
        imageProduct3 = UIImage(named: "default_image_select")
        image1View.image = imageProduct1
        image2View.image = imageProduct2
        image3View.image = imageProduct3
        
        productCategoryTextField.inputView = picker
        sellerPhoneNumberTextField.text = MyApp.shared.phone
        //**********************************************************************
        image1View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage1View)))
        image1View.isUserInteractionEnabled = true
        image2View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage2View)))
        image2View.isUserInteractionEnabled = true
        image3View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage3View)))
        image3View.isUserInteractionEnabled = true
        //*************************************************************************
        for a in 0...2 {
            let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
            let profileRef = Storage.storage().reference(withPath: "productImages/\(a+1)\(profileImageFileName)")
            profileRef.getData(maxSize: 102240000) { (imageData, error) in
                if error == nil {
                    print("Load profile from firebase success",imageData)
                    
                    let image = UIImage(data: imageData!)
                    DispatchQueue.main.async {
                        if a == 0{
                        self.image1View.image = image
                        }
                        if a == 1 {
                            self.image2View.image = image
                        }
                        if a == 2 {
                            self.image3View.image = image
                        }
                        
                    }
                }
                else {
                    print("Load profile from Firebase fail:", error?.localizedDescription)
                }
            }
        }

    }// end on view
    
    func loadDataFromFirebaseDB(){
        if Auth.auth().currentUser != nil {
            let uID = Auth.auth().currentUser?.uid
            let userEmail = Auth.auth().currentUser?.email
            let courseRef = Database.database().reference(withPath: "userprofiles").child(uID!)
            courseRef.observe(.value, with: { (snapshot) in
                for courseSnapshot in snapshot.children.allObjects as! [DataSnapshot]{
                    print("*************************************")
                    let course = courseSnapshot.value as? NSDictionary
                    let myimage = course!["image"] as? String ?? ""//"default_image_select"

                        let myApp = MyApp.shared
                        DispatchQueue.main.async {
                            //myApp.testingImage = myimage
                            myApp.testingImage = myimage
                            print("My Image is:")
                            print(myimage)
                            self.loadAndDisplayArticleImage(stringurl: myApp.testingImage)
                        }
                }
            })
        } else {
            print("No user sign in...")
        }
    }
    
    func loadAndDisplayArticleImage(stringurl: String){
        let imageUrl = URL(string: stringurl)
        let task = URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                   // self.articleImageView.image = #imageLiteral(resourceName: "img_error_image")
                } else {
                    self.image1View.image = UIImage(data: data!)
                //self.articleImageView.image = UIImage(data: data!)
                }
            }
        }
        task.resume()
    }
    func handleSelectImage1View(){
        print("i touch image 1")
        self.imageOrder = 1
        self.startSelectImage()
    }
    func handleSelectImage2View(){
        print("i touch image 2")
        self.imageOrder = 2
        self.startSelectImage()
    }
    func handleSelectImage3View(){
        print("i touch image 3")
        self.imageOrder = 3
        self.startSelectImage()
    }
    // **************************************************
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        
        let selectedImage1 = info[UIImagePickerControllerOriginalImage] as! UIImage

        switch imageOrder {
            case 1:
            image1View.image = selectedImage1
            imageProduct1 = selectedImage1
            case 2:
            image2View.image = selectedImage1
            imageProduct2 = selectedImage1
            case 3:
            image3View.image = selectedImage1
            imageProduct3 = selectedImage1
        default: break
            // do nothing
        }

    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return product_categolary.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return product_categolary[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(product_categolary[row])
        productCategoryTextField.text = product_categolary[row]
        self.view.endEditing(false)
    }

    func startSelectImage(){
        print("Start choose image")
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.sourceType = .photoLibrary
        imagePickerVc.delegate = self
        imagePickerVc.allowsEditing = true
        present(imagePickerVc, animated: true, completion: nil)
    }
    
    @IBAction func onClickSelNowButton(_ sender: UIButton) {
        let myTitle = productTitleTextField.text
        let myPhone = sellerPhoneNumberTextField.text
        let myPrice = priceOfProductTextField.text
        let myCategory = productCategoryTextField.text
        // checking blank requirement for field user input
        
        if Auth.auth().currentUser != nil {
            let uID = Auth.auth().currentUser?.uid
            uploadProfileImage(selectedImageProfile: imageProduct1, userid: uID!, imageOrder: 1)
            uploadProfileImage(selectedImageProfile: imageProduct2, userid: uID!, imageOrder: 2)
            uploadProfileImage(selectedImageProfile: imageProduct3, userid: uID!, imageOrder: 3)
//            if Auth.auth().currentUser != nil {
//                let uID = Auth.auth().currentUser?.uid
//                let id = NSUUID.init(uuidString: uID!)
//                let proNum = MyApp.shared.TotalProductNumber + 1
//                ref = Database.database().reference()
//                self.ref.child("userprofiles/myProduct/\(String(describing: id))/numberOfproduct").setValue(proNum)
//
//            }
        } else {
            
        }
        
//        if myTitle == "" || myPhone == "" || myPrice == "" || myCategory == ""{
//            self.showMessage(title: "Missing requiment", Message: "You cannot leave blank for any field!!")
//        }
//        else{
//             print("product was sold!!")
//        }
       
        
    }
    func uploadProfileImage(selectedImageProfile: UIImage, userid:String, imageOrder:Int){
        // upload image to firebase
        
        let myImageData = UIImageJPEGRepresentation(selectedImageProfile, 0.75)
        let imageName = NSUUID.init(uuidString: userid)
        let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
        
        //let profileRef = Storage.storage().reference(withPath: "users_profile_image/\(imageName)")
        print("My ID is:",userid)
        
        // update product number
        let proNum = MyApp.shared.TotalProductNumber + 1
        ref = Database.database().reference()
        self.ref.child("userprofiles/\(userid)/numberOfproduct").setValue(proNum)
        ///
        
        //let profileRef = Storage.storage().reference(withPath: "users_profile_image/\(userid)")
        let profileRef = Storage.storage().reference(withPath: "productsimage/\(imageOrder)\(profileImageFileName)")
        profileRef.putData(myImageData!, metadata: nil) { (metaData, error) in
            if error == nil {
                print("Upload profile", metaData)
                if let profileUrl = metaData?.downloadURL(){
                    let userProfileRef = Database.database().reference(withPath: "userprofiles/\(userid)/product/product\(MyApp.shared.TotalProductNumber + 1)/image\(imageOrder)")
                        userProfileRef.setValue(profileUrl.absoluteString)
                }
            }
            else {
                print("Up load to firebase Storage fail:\(error?.localizedDescription)")
            }
        }
        
    }
    func showMessage(title:String, Message:String ){
        let popupDialog = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        popupDialog.addAction(okAction)
        self.present(popupDialog, animated: true, completion: nil)
    }
    
}
