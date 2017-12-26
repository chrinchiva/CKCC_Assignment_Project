//
//  loginController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/15/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
var selectedImage : UIImage!
class loginController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var backgroundUIView: UIView!
    @IBOutlet weak var loginUIView: UIView!
    @IBOutlet weak var segmentLoginControl: UISegmentedControl!
 
    @IBOutlet weak var loginUsernameField: UITextField!
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    @IBOutlet weak var loginPhoneNumberField: UITextField!
    @IBOutlet weak var loginImageView: UIImageView!

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
    super.viewDidLoad()
         selectedImage = UIImage(named: "default_image_select")
        backgroundUIView.backgroundColor = UIColor(r: 0, g: 151, b: 155)
        loginUIView.backgroundColor = UIColor(r: 0, g: 151, b: 155)
        loginUsernameField.isHidden = true
        loginPhoneNumberField.isHidden = true
        loginImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageProfile)))
        checkIfuserisLoggedIn()
        loginImageView.isUserInteractionEnabled = true
       
        
    }
    // when register or login
    @IBAction func onClickRegisterButton(_ sender: UIButton) {
        alertRememberPasswordRequest(title: "Information", message: "log in now")
        
    }
    // when segment control selected
    func handleLoginRegister(){
        
        if segmentLoginControl.selectedSegmentIndex == 0
        {
            handleLogin()
        }else{
            loginImageView.isUserInteractionEnabled = true
            handleSignUp()
        }
    }
    //new uesr login action
    func handleLogin(){
        guard let uemail = loginEmailField.text, let upassword = loginPasswordField.text else{
        self.showMessage(title: "Information", Message: "email or password is blank")
            return
        }
    
        Auth.auth().signIn(withEmail: uemail , password: upassword) { (user, error) in
            if error != nil {
                self.showMessage(title: "Information", Message: (error?.localizedDescription)!)
                return
            }else {
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "segue_profile", sender: nil)
            }
        }

    }
    // user signup action
    func handleSignUp(){
        guard let uemail = loginEmailField.text, let upassword = loginPasswordField.text,
            let uusername = loginUsernameField.text, let uphonenumber = loginPhoneNumberField.text else{
            self.showMessage(title: "Information", Message: "email or password is blank")
            return
        }
        Auth.auth().createUser(withEmail: uemail, password: upassword) { (user, error) in
            if error != nil {
                // on error sign up action
                self.showMessage(title: "Information", Message: (error?.localizedDescription)!)
                return
            }

            // sign in befor setting image and other information
            Auth.auth().signIn(withEmail: uemail , password: upassword) { (user, error) in
                if error != nil {
                    self.showMessage(title: "Information", Message: (error?.localizedDescription)!)
                    return
                }else {
                    self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "segue_profile", sender: nil)
                }
            }
            // end signed in
            
                self.settingUserprofile(username: self.loginUsernameField.text!, email: self.loginEmailField.text!, pass: self.loginPasswordField.text!, phone: self.loginPhoneNumberField.text!)
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = uusername
            changeRequest?.commitChanges { (error) in
                if let error = error {
                    self.showMessage(title: "Error", Message: error.localizedDescription)
                }
            }
            self.dismiss(animated: true, completion: nil)
            self.showMessage(title: "Information", Message: "\(uemail) successfully login")
        }
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
        loginImageView.image = selectedImage
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
    @IBAction func onClickSegmentChanged(_ sender: UISegmentedControl) {
        if segmentLoginControl.selectedSegmentIndex == 0{
            loginUsernameField.isHidden = true
            loginPhoneNumberField.isHidden = true
            loginPasswordField.text = ""
        }else{
            loginPhoneNumberField.isHidden = false
            loginUsernameField.isHidden = false
        }
    }
    //********************** setting profile user *************************************
    func settingUserprofile(username:String, email:String, pass:String, phone: String){
        if Auth.auth().currentUser != nil {
            let uID = Auth.auth().currentUser?.uid
            let path1 = "tblUsers"
            self.ref.child(path1).child(uID!).child("username").setValue(username)
            self.ref.child(path1).child(uID!).child("email").setValue(email)
            self.ref.child(path1).child(uID!).child("password").setValue(pass)
            self.ref.child(path1).child(uID!).child("phone").setValue(phone)
            self.ref.child(path1).child(uID!).child("numberOfproduct").setValue(0)
            
            let path2 = "userAddCart"
            ref = Database.database().reference()
            //let path3 = "image\(newCartNumber)"
            self.ref.child(path2).child(uID!).child("addCartNumber").setValue(0)
            //self.ref.child(path1).child(uID!).child("product").child(path2).setValue(globalUserID)
            
            
            self.uploadProfileImage(selectedImageProfile: selectedImage, userid: uID!)
        } else {
            
        }
    }
    //*********************************************************************************
    func checkIfuserisLoggedIn() {
        if Auth.auth().currentUser?.uid == nil
        {
            showMessage(title: "Information", Message: "Log in first")
        } else{
            let uid = Auth.auth().currentUser?.uid
            ref = Database.database().reference()
            ref.child("userprofile").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let myApp = MyApp.shared
                    //myApp.username = dictionary["username"] as? String
                }
                
            }, withCancel: nil)
        }
        
    }
    func showMessage(title:String, Message:String ){
        let popupDialog = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        popupDialog.addAction(okAction)
        self.present(popupDialog, animated: true, completion: nil)
    }
    func alertRememberPasswordRequest(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("I have save the remember request")
            self.handleLoginRegister()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("i dismiss the remember request")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIColor {
    convenience init(r: CGFloat, g:CGFloat, b: CGFloat) {
        self.init   (red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
