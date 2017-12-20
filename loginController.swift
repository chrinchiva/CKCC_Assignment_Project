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
class loginController: UIViewController {

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
        backgroundUIView.backgroundColor = UIColor(r: 0, g: 151, b: 155)
        loginUIView.backgroundColor = UIColor(r: 0, g: 151, b: 155)
        loginUsernameField.isHidden = true
        loginPhoneNumberField.isHidden = true
        checkIfuserisLoggedIn()
    }
    // when register or login
    @IBAction func onClickRegisterButton(_ sender: UIButton) {handleLoginRegister()}
    // when segment control selected
    func handleLoginRegister(){
        if segmentLoginControl.selectedSegmentIndex == 0
        {
            handleLogin()
        }else{
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
            //self.ref.child("userprofiles/\(String(describing: uID))/username").setValue(username)
            //self.ref.child("userprofiles/\(String(describing: uID))/email").setValue(email)
            //self.ref.child("userprofiles/\(String(describing: uID))/password").setValue(pass)
            self.ref.child("userprofiles").child(uID!).child("username").setValue(username)
            self.ref.child("userprofiles").child(uID!).child("email").setValue(email)
            self.ref.child("userprofiles").child(uID!).child("password").setValue(pass)
            self.ref.child("userprofiles").child(uID!).child("phone").setValue(phone)
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
    
}

extension UIColor {
    convenience init(r: CGFloat, g:CGFloat, b: CGFloat) {
        self.init   (red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
