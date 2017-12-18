//
//  NewLoginViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/15/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class NewLoginViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogout))
    
    }

    func handleLogout()  {
        let loginController = LogInViewController()
        present(loginController, animated: true)
        
    }
}
