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
    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var sellerPhoneNumberTextField: UITextField!
    @IBOutlet weak var priceOfProductTextField: UITextField!
    @IBOutlet weak var disciptionProductTextField: UITextField!
    @IBOutlet weak var productCategoryTextField: UITextField!
    var imageOrder = 0
    var selectedImage:[UIImage]!
    //var imageProduct : [UIImage]!
    var imageProduct1 : UIImage!
    

    var product_categolary = ["mobilephone","computer","apparelForMale","apparelForFemale","automobile","electricalAccessory","beauty&health","electronicComponent","jewelry","toy","watch","shoe","others"]
    let picker = UIPickerView()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.alpha = 0.5
        imageProduct1 = UIImage(named: "default_image_select")
        image1View.image = imageProduct1

        productCategoryTextField.inputView = picker
        sellerPhoneNumberTextField.text = MyApp.shared.phone
        //**********************************************************************
        image1View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage1View)))
        image1View.isUserInteractionEnabled = true
        //*************************************************************************


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
    // **************************************************
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let selectedImage1 = info[UIImagePickerControllerOriginalImage] as! UIImage
        image1View.image = selectedImage1
        imageProduct1 = selectedImage1

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

            uploadProfileImage(selectedImageProfile: imageProduct1, userid: uID!)

        } else {
            
        }
        
    }
    func uploadProfileImage(selectedImageProfile: UIImage, userid:String){
        // upload image to firebase
        let myImageData = UIImageJPEGRepresentation(selectedImageProfile, 0.75)
        let imageName = NSUUID.init(uuidString: userid)
        let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
        
        //let profileRef = Storage.storage().reference(withPath: "users_profile_image/\(imageName)")
        print("My ID is:",userid)
        
        // update product number
        let proNum = MyApp.shared.numberOfAllImage + 1
        print("myapp value:", proNum)
        ref = Database.database().reference()
        self.ref.child("numberOfAllImage").setValue(proNum)
        ///
        
        //let profileRef = Storage.storage().reference(withPath: "users_profile_image/\(userid)")
        let profileRef = Storage.storage().reference(withPath: "productsimage/image\(proNum)")
        profileRef.putData(myImageData!, metadata: nil) { (metaData, error) in
            if error == nil {
                print("Upload profile", metaData)
                if let profileUrl = metaData?.downloadURL(){
                    let userProfileRef = Database.database().reference(withPath: "allImage/tbl/image\(MyApp.shared.numberOfAllImage + 1)")
                        userProfileRef.setValue(profileUrl.absoluteString)
                }
                self.productInforUpload(proNum: proNum, userid: userid)
                if let profileUrl = metaData?.downloadURL(){
                    let userProfileRef = Database.database().reference(withPath: "AllimageInformation/image\(proNum)/image")
                    userProfileRef.setValue(profileUrl.absoluteString)
                    
                }
                
            }
            else {
                print("Up load to firebase Storage fail:\(error?.localizedDescription)")
            }
            self.showMessage(title: "Information", Message: "your product uploaded.")
        }
    }
    func productInforUpload(proNum:Int, userid:String){
        // upload information to firebase
        let path1 = "AllimageInformation/image\(proNum)"
        
        self.ref.child(path1).child("UserID").setValue("image\(proNum)")
        self.ref.child(path1).child("productTitle").setValue(productTitleTextField.text)
        self.ref.child(path1).child("phone").setValue(sellerPhoneNumberTextField.text)
        self.ref.child(path1).child("price").setValue(priceOfProductTextField.text)
        self.ref.child(path1).child("category").setValue(productCategoryTextField.text)
        self.ref.child(path1).child("category").setValue(productCategoryTextField.text)
        self.ref.child(path1).child("description").setValue(disciptionProductTextField.text)
        
        self.ref.child(path1).child("username").setValue(MyApp.shared.username)
        self.ref.child(path1).child("email").setValue(MyApp.shared.email)
        
    }
    func showMessage(title:String, Message:String ){
        let popupDialog = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        popupDialog.addAction(okAction)
        self.present(popupDialog, animated: true, completion: nil)
    }
    
}
