//
//  UserDetailViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/11/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase

class UserDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    // create database reference
    var ref: DatabaseReference!
    var handleImage: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector)
        
        ref = Database.database().reference()
        handleImage = ref?.child("profile").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String
            {
                
                //self.imageView.image
                //self.usernameList.append(item)
                //self.myListView.reloadData()
                DispatchQueue.main.async {
                    print("I got ***********************************************************")
                    print(item)
                    print("I got ***********************************************************")
                }
            }
        })
        
        
        
       
        
        
        nameLabel.text = MyApp.shared.username
        emailLabel.text = MyApp.shared.email
        if FBSDKProfile.current() != nil
        {
            userDisplayInf()
            
        }
        else
        {
            NotificationCenter.default.addObserver(forName: Notification.Name.FBSDKProfileDidChange, object: nil, queue: .main, using: { (notification) in
                print("[Notification]Profile did changed")
                self.userDisplayInf()
            })
        }
    }

    func userDisplayInf()
    {
        let user = FBSDKProfile.current()!
        // print current user data to blank box
        let profileImageSize = CGSize(width: 120, height: 120)
        let profileImageUrl = user.imageURL(for: .normal, size: profileImageSize)!
        let task = URLSession.shared.dataTask(with: profileImageUrl) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    if image != nil {
                        self.profileImageView.image = image
                    }
                }
            }
        }
        task.resume()
        
        // Load email, dob, pob
        let request = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,email,birthday,hometown"])!
        request.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print("Load more info error: ", error!.localizedDescription)
            } else {
                let resultObject = result as! [String:Any]
                //let email = resultObject["email"] as! String
                //let birthday = resultObject["birthday"] as! String
                //let hometownObject = resultObject["hometown"] as! [String:Any]
                //let hometown = hometownObject["name"] as! String
                DispatchQueue.main.async {
                    //self.emailLabel.text = email
                    //self.emailLabel.text = email
                    //self.dobLabel.text = birthday
                    //self.pobLabel.text = hometown
                }
            }
        })
        
        
        
    }
}

