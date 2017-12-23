//
//  SellController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/21/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
class SellController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var image1View: UIImageView!
    @IBOutlet weak var image2View: UIImageView!
    @IBOutlet weak var image3View: UIImageView!
    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var sellerPhoneNumberTextField: UITextField!
    @IBOutlet weak var priceOfProductTextField: UITextField!
    var imageOrder = 0
    var selectedImage:[UIImage]!
    
    @IBOutlet weak var productCategoryTextField: UITextField!
    var product_categolary = ["Book","Phone","Computer","Shirt","Book","Phone","Computer","Shirt","Book","Phone","Computer","Other"]
    let picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.alpha = 0.5
        
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
                        //self.image1View.image = image
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
        
        // *******************************************************
        //loadDataFromFirebaseDB()
        

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
        //
//        let userID = Auth.auth().currentUser?.uid
//        ref = Database.database().reference()
//        ref.child("userprofiles").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            let username = value?["username"] as? String ?? ""
        //
        
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
            case 2:
            image2View.image = selectedImage1
            case 3:
            image3View.image = selectedImage1
        default: break
            // do nothing
        }
        // upload image to firebase
        let myImageData = UIImageJPEGRepresentation(selectedImage1, 0.75)
        let userID = Auth.auth().currentUser?.uid
        let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"

        let profileRef = Storage.storage().reference(withPath: "productImages/\(imageOrder)\(profileImageFileName)")
        profileRef.putData(myImageData!, metadata: nil) { (metaData, error) in
            if error == nil {
                print("Upload profile", metaData)
                
                //////
                let uID = Auth.auth().currentUser?.uid
                //self.ref.child("userprofiles/\(String(describing: uID))/username").setValue(username)
                //self.ref.child("userprofiles/\(String(describing: uID))/email").setValue(email)
                //self.ref.child("userprofiles/\(String(describing: uID))/password").setValue(pass)
//                self.ref.child("userprofiles").child(uID!).child("username").setValue(username)
//                self.ref.child("userprofiles").child(uID!).child("email").setValue(email)
//                self.ref.child("userprofiles").child(uID!).child("password").setValue(pass)
//                self.ref.child("userprofiles").child(uID!).child("phone").setValue(phone)
                
                ////
                if let profileUrl = metaData?.downloadURL(){
                    let userProfileRef = Database.database().reference(withPath: "userprofiles/userimage/image")
                    userProfileRef.setValue(profileUrl.absoluteString)
                    
                }
            }
            else {
                print("Up load to firebase Storage fail:\(error?.localizedDescription)")
            }
        }
    }
//    private func registerUserIntoDatabaseWithID(uid: String, values: [String : AnyObject]){
//        let ref = Database.database().reference(fromURL: "https://firebasestorage.googleapis.com/v0/b/onlineshoppingproject-a377a.appspot.com/")
//        let userReference = ref.child("Users").child(uid)
//        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//            if err != nil {
//                print(err)
//                return
//            }
//            self.dismiss(animated: true, completion: nil)
//        })
//    }

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
    
    
    // choose image for sell view product
//    @IBAction func onClickBrowsePhotos(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Select image", message: "Which image order?", preferredStyle: UIAlertControllerStyle.alert)
//
//        alert.addAction(UIAlertAction(title: "Set image1", style: UIAlertActionStyle.default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//            print("select image 1")
//            self.imageOrder = 1
//            self.startSelectImage()
//        }))
//        alert.addAction(UIAlertAction(title: "Set image2", style: UIAlertActionStyle.default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//            print("select image 2")
//            self.imageOrder = 2
//            self.startSelectImage()
//        }))
//        alert.addAction(UIAlertAction(title: "Set image3", style: UIAlertActionStyle.default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//            print("select image 3")
//            self.imageOrder = 3
//            self.startSelectImage()
//        }))
//
//        self.present(alert, animated: true, completion: nil)
//    }
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
        
        if myTitle == "" || myPhone == "" || myPrice == "" || myCategory == ""{
            self.showMessage(title: "Missing requiment", Message: "You cannot leave blank for any field!!")
        }
        else{
             print("product was sold!!")
        }
       
        
    }
    func showMessage(title:String, Message:String ){
        let popupDialog = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        popupDialog.addAction(okAction)
        self.present(popupDialog, animated: true, completion: nil)
    }
    
}
