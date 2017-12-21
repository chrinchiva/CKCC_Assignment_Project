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
    
    var ref: DatabaseReference!
    var handleUsername: DatabaseHandle?
    var handlePassword: DatabaseHandle?
    var handleEmail: DatabaseHandle?
    var currentData = [String]()
    var databaseHandle : DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // store current user to name display label
        
      
        
        if Auth.auth().currentUser?.uid == nil
        {
            handleLogout()
            
        }else {
            //print("******************* start profile image *******************************")
           
            //loadDataFromFirebaseDB()
            loadSingleFile()
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
            let iemail = useremail
            let iphone = userphone
            let iuser = username
            
            //print("my user name is **********************")
            //print(user)
            self.profileUsername.text = iuser
            self.profileEmail.text = iemail
            self.profilePhoneView.text = iphone
            // save data off line
            let myApp = MyApp.shared
                myApp.email = iemail
                myApp.username = iuser
                myApp.phone = iphone
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func loadDataFromFirebaseDB(){
        if Auth.auth().currentUser != nil {
            //let userID = Auth.auth().currentUser?.uid
            let userEmail = Auth.auth().currentUser?.email
            let courseRef = Database.database().reference(withPath: "userprofiles")
            courseRef.observe(.value, with: { (snapshot) in
                for courseSnapshot in snapshot.children.allObjects as! [DataSnapshot]{
                
                    let course = courseSnapshot.value as! [String:Any]
                    let myName = course["username"] as? String ?? ""
                    let myPassword = course["password"] as? String ?? ""
                    let myEmail  = course["email"] as? String ?? ""
                    let myPhone = course["phone"] as? String ?? ""
                    //print("username:\(name)")
                    //print("password:\(myPassword)")
                    //print("email:\(myEmail)")
                    print(course)
                    if myEmail == userEmail {
                        let myApp = MyApp.shared
                        DispatchQueue.main.async {
                            myApp.email = myEmail
                            myApp.username = myName
                            myApp.password = myPassword
                            myApp.phone = myPhone
                            print("The current sign in is ")
                            print(MyApp.shared.username)
                            print(MyApp.shared.email)
                            print(MyApp.shared.password)
                            self.profileUsername.text = myName
                            self.profileEmail.text = myEmail
                            self.profilePhoneView.text = myPhone
                        }
                    }else{
                        
                    }
                    
                }
            })
        } else {
            print("No user sign in...")
        }
        
        
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
