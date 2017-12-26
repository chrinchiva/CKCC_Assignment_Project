//
//  editProfileViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/26/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class editProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var usernameChangeText: UITextField!
    @IBOutlet weak var phoneChangeText: UITextField!
    @IBOutlet weak var newPasswordChangeText: UITextField!
    @IBOutlet weak var oldPasswordChangeText: UITextField!
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSingleFile()
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageProfile)))
        imageview.isUserInteractionEnabled = true
    }
    func handleSelectImageProfile(){
        print("Image is selected")
        startSelectImage()
    }
    func startSelectImage(){
        print("Start choose image")
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.sourceType = .photoLibrary
        imagePickerVc.delegate = self
        imagePickerVc.allowsEditing = true
        present(imagePickerVc, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("The image selcted is:")
        print(selectedImage)
        imageview.image = selectedImage
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickButtonConfirm(_ sender: UIButton) {
        var username = ""
        var phone = ""
        let newpass = ""
        let oldpass = ""
        //newpass = newPasswordChangeText.text!
        // oldpass = oldPasswordChangeText.text!
        
        if oldPasswordChangeText.text != nil {
            if newPasswordChangeText.text != oldPasswordChangeText.text {
                if usernameChangeText.text == ""{
                    username = MyApp.shared.username
                }
                else{
                    username = usernameChangeText.text!
                }
                
                if phoneChangeText.text == ""{
                    phone = MyApp.shared.phone
                }
                else {
                    phone = phoneChangeText.text!
                }
                // process changing new profile
                let myNewPassword = newPasswordChangeText.text
                saveNewProfile(username: username, phone: phone, password: myNewPassword!)
                
                
                
            }else{
                self.showMessage(title: "Alert", Message: "password not match")
            }
        }else{
            self.showMessage(title: "Information", Message: "Fill password before saving data.")
        }
        
    }
    
    func saveNewProfile(username:String, phone:String, password:String){
        if Auth.auth().currentUser != nil{
            let uID = Auth.auth().currentUser?.uid
            ref = Database.database().reference()
            let path1 = "tblUsers"
            self.ref.child(path1).child(uID!).child("username").setValue(username)
            self.ref.child(path1).child(uID!).child("password").setValue(password)
            self.ref.child(path1).child(uID!).child("phone").setValue(phone)
            Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                if error != nil {
                    print("Error",error?.localizedDescription)
                }else{
                    self.showMessage(title: "Message", Message: "Profile changed")
                }
                
            }
            self.uploadProfileImage(selectedImageProfile: selectedImage, userid: uID!)
            
        }
    }
    func loadSingleFile(){
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("tblUsers").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let userImage = value?["profileimage"] as? String ?? "default_image_select"

//            print("My profile image is : ***********:")
//            print(iimage)
//            // save data off line
//            let myApp = MyApp.shared
//            myApp.email = iemail
//            myApp.username = iuser
//            myApp.phone = iphone
//            myApp.testingImage = userImage
            //articles
            // self.loadImagefromFirebaseDB(imageUrl: MyApp.shared.testingImage)
            self.loadImagefromFirebaseDB(imageUrl: userImage)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
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
                        self.imageview.image = image
                    } else {
                        print("return default ")
                        self.imageview.image = #imageLiteral(resourceName: "default_image_select")
                    }
                }
            }
        }
        task.resume()
        
    }
    func uploadProfileImage(selectedImageProfile: UIImage, userid:String){
        // upload image to firebase
        
        let myImageData = UIImageJPEGRepresentation(selectedImageProfile, 0.75)
        let imageName = NSUUID.init(uuidString: userid)
        let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
        
        //let profileRef = Storage.storage().reference(withPath: "users_profile_image/\(imageName)")
        //print("My ID is:",userid)
        let profileRef = Storage.storage().reference(withPath: "userImageProfiles/\(userid)")
        profileRef.putData(myImageData!, metadata: nil) { (metaData, error) in
            if error == nil {
                print("Upload profile", metaData)
                if let profileUrl = metaData?.downloadURL(){
                    let userProfileRef = Database.database().reference(withPath: "tblUsers/\(userid)/profileimage")
                    userProfileRef.setValue(profileUrl.absoluteString)
                }
            }
            else {
                print("Up load to firebase Storage fail:\(error?.localizedDescription)")
            }
        }
    }
//    guard let uemail = loginEmailField.text, let upassword = loginPasswordField.text,
//    let uusername = loginUsernameField.text, let uphonenumber = loginPhoneNumberField.text else{
//    self.showMessage(title: "Information", Message: "email or password is blank")
//    return
//    }
    
    func showMessage(title:String, Message:String ){
        let popupDialog = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        popupDialog.addAction(okAction)
        self.present(popupDialog, animated: true, completion: nil)
    }

}
