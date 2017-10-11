//
//  LoginViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/4/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func onLoginButtonClick(_ sender: Any) {
        let inputUsername = usernameTextField.text!
        let inputPassword = passwordTextField.text!
        
    }
    
    func processLogin(username: String, password: String) {
        let loginUrl = "http://localhost/login/login.php"
        let url = URL(string: loginUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let dataString = "username=\(username)&password=\(password)"
        let dataToSubmit = dataString.data(using: .utf8)
        request.httpBody = dataToSubmit
        let task = URLSession.shared.dataTask(with: request){(data, respone, error) in
            self.processLoginResult(data: data)
        }
        task.resume()
    }
    func processLoginResult(data: Data?)  {
        let jsonDict = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
        let responeCode = jsonDict["_code"] as? Int
        if(responeCode != nil){
            print("login Fail")
            let message = jsonDict["_message"] as! String
            DispatchQueue.main.async {
                let popupDialog = UIAlertController(title: "Login fail", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                popupDialog.addAction(okAction)
                self.present(popupDialog, animated: true, completion: nil)
                
            }
        }
        else{
            let id = jsonDict["_id"] as! Int
            let name = jsonDict["_name"] as! String
            let username = jsonDict["_username"] as! String
            let profilePicture = jsonDict["_profile_picture"] as! String
            let token = jsonDict["_token"] as! String
            print("Login success:", name)
            
            
        }
    }
    
}
