//
//  profileController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/15/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class profileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundUIView: UIView!
    @IBOutlet weak var profilePhoneView: UILabel!
    @IBOutlet weak var navigationBarWithLogout: UINavigationBar!
    
    var ref: DatabaseReference!
    var handleUsername: DatabaseHandle?
    var handlePassword: DatabaseHandle?
    var handleEmail: DatabaseHandle?
    var currentData = [String]()
    var databaseHandle : DatabaseHandle?
    var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // store current user to name display label
        if Auth.auth().currentUser?.uid == nil
        {
            handleLogout()
            
        }else {
            //print("******************* start profile image *******************************")
            //loadDataFromFirebaseDB()
            let uID = Auth.auth().currentUser?.uid
            loadSingleFile()
        }
    }
    
    // strill testing progress
    func uploadProfileImage(selectedImageProfile: UIImage, userid:String){
        // upload image to firebase
        let myImageData = UIImageJPEGRepresentation(selectedImageProfile, 0.75)
        let imageName = NSUUID.init(uuidString: userid)
        let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
        
        let profileRef = Storage.storage().reference(withPath: "users_profile_image/\(imageName)")
        profileRef.putData(myImageData!, metadata: nil) { (metaData, error) in
            if error == nil {
                print("Upload profile", metaData)
                //// put image link to dabase
                if let profileUrl = metaData?.downloadURL(){
                    let userProfileRef = Database.database().reference(withPath: "userprofiles/\(imageName)/image")
                    DispatchQueue.main.async {
                        userProfileRef.setValue(profileUrl.absoluteString)
                    }
                    
                }
                //
            }
            else {
                print("Up load to firebase Storage fail:\(error?.localizedDescription)")
            }
        }
    }
    func loadSingleFile(){
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("userprofiles").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let useremail  = value?["email"] as? String ?? ""
            let userphone = value?["phone"] as? String ?? ""
            let userImage = value?["image"] as? String ?? "default_image_select"
            let iemail = useremail
            let iphone = userphone
            let iuser = username
            let iimage = userImage
            
            //print("my user name is **********************")
            //print(user)
            self.profileUsername.text = iuser
            self.profileEmail.text = iemail
            self.profilePhoneView.text = iphone

            print("My profile image is : ***********:")
            print(iimage)
            // save data off line
            let myApp = MyApp.shared
                myApp.email = iemail
                myApp.username = iuser
                myApp.phone = iphone
                myApp.testingImage = iimage
                //articles
           // self.loadImagefromFirebaseDB(imageUrl: MyApp.shared.testingImage)
            self.loadImagefromFirebaseDB(imageUrl: iimage)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        // load number of image posted by users
        ref.child("numberOfAllImage").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! String? ?? "0"
            let result = Decimal(string: value)
            print("Image number image is here:")
            print(value)
            var i = result!
            print(i)

        }){(error) in
            print(error.localizedDescription)
        }
        // load number of product number
        
        if Auth.auth().currentUser != nil {
            let uid  = Auth.auth().currentUser?.uid
            //"userprofiles/\(userid)/product/product1/image\(imageOrder)"
            ref.child("userprofiles").child(userID!).child("numberOfproduct").observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                let value = snapshot.value as! Int? ?? 0
                //let result = Decimal(string: value)
                let myApp = MyApp.shared
                myApp.TotalProductNumber = value
                
                print("Image productnumber is here:", MyApp.shared.TotalProductNumber)
               
                
                
            }){(error) in
                print(error.localizedDescription)
            }

        }else{
            
        }
    }
    func loadImagefromFirebaseDB(imageUrl: String){
        let imageUrl = URL(string: imageUrl)!
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data {
                print("the respone data is")
                print(data)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    if image != nil {
                        print("return true ")
                        self.profileImageView.image = image
                    } else {
                        print("return default ")
                        self.profileImageView.image = #imageLiteral(resourceName: "default_image_select")
                    }
                }
            }
        }
        task.resume()

    }

    override func viewWillAppear(_ animated: Bool) {
        loadSingleFile()
        //loadDataFromFirebaseDB()
        //self.profileUsername.text = MyApp.shared.username
        //self.profileEmail.text = MyApp.shared.email
    }
    @IBAction func onClickLogoutButton(_ sender: UIBarButtonItem) {
        handleLogout()
    }
    
    func handleLogout()  {
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        performSegue(withIdentifier: "segue_logout", sender: nil)
        //self.performSegue(withIdentifier: "segue_profile", sender: nil)
    }
    
    
    @IBAction func onClickEditButton(_ sender: UIBarButtonItem) {
//        let myImage = #imageLiteral(resourceName: "ic_list_2x")
//        let myImageData = UIImageJPEGRepresentation(myImage, 0.75)
//
//        let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
//        let profileRef = Storage.storage().reference(withPath: "profile/\(profileImageFileName)")
//        profileRef.putData(myImageData!, metadata: nil) { (metaData, error) in
//            if error == nil {
//                print("Upload profile", metaData)
//            }
//            else {
//                print("Up load to firebase Storage fail:\(error?.localizedDescription)")
//            }
//
//        }
        
        
    }
    
    @IBAction func onClickUpdateImageButton(_ sender: UIButton) {// download data from server of firebase
        let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
        let profileRef = Storage.storage().reference(withPath: "profile/\(profileImageFileName)")
        profileRef.getData(maxSize: 102240000) { (imageData, error) in
            if error == nil {
            print("Load profile from firebase success")
                let image = UIImage(data: imageData!)
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                    
                    
                    let uid = Auth.auth().currentUser?.uid
                    self.ref = Database.database().reference()
                    self.ref.child("userprofile").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            //let myApp = MyApp.shared
                            //myApp.username = dictionary["username"] as? String
                            //myApp.email = dictionary["email"] as? String
                            
                            //self.profileUsername.text = MyApp.shared.username
                            //self.profileEmail.text = MyApp.shared.email
                            self.profileUsername.text = dictionary["username"] as? String
                            self.profileEmail.text = dictionary["email"] as? String
                        }
                        
                    }, withCancel: nil)
                }
            }else {
                print("Load profile from Firebase fail:", error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func onClickButtonChooseImage(_ sender: UIButton) {
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.sourceType = .photoLibrary
        imagePickerVc.delegate = self
        present(imagePickerVc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set selected image to profile image view
        //profileImageView.image = selectedImage

        // upload image to firebase
        let myImageData = UIImageJPEGRepresentation(selectedImage, 0.75)
        
        let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
        let profileRef = Storage.storage().reference(withPath: "profile/\(profileImageFileName)")
        profileRef.putData(myImageData!, metadata: nil) { (metaData, error) in
            if error == nil {
                print("Upload profile", metaData)
            }
            else {
                print("Up load to firebase Storage fail:\(error?.localizedDescription)")
            }
            
        }
        
    }
    
    @IBAction func onClickSellMyProductButton(_ sender: UIButton) {
    
    }
    
}
