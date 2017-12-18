//
//  profileController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/15/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
class profileController: UIViewController {
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // store current user to name display label
        profileUsername.text = MyApp.shared.username
        
        if Auth.auth().currentUser?.uid == nil
        {
            handleLogout()
        }
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
    
    }
    
}
