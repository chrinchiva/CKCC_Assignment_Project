//
//  provinceNameViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/15/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class provinceNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var provinceName:[String] = ["Phnom Penh","Sihanouk","Takeo","Kandal","Battombong","Prey Veng","Kom Pong Speu","Svay Reang","Phnom Penh","Sihanouk","Takeo","Kandal","Battombong","Prey Veng","Kom Pong Speu","Svay Reang"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinceName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell_province")
        cell.textLabel?.text = provinceName[indexPath.row]
        return cell
    }
    
}
