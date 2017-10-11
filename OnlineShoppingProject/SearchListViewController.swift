//
//  SearchListViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/9/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class SearchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var itemName = ["iPhone 6+","Sumsung s6","Nokia 7480", "Computer DELL","Window Phone","iPhone 4","Sumsung s8","Nokia 1280", "Computer ASUS","Window phone version 2.1"]
    var itemPrice = [120,200,330,400,500,12,54,34,320,567]
    var itemImage = ["MSIPC.png"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_search", for: indexPath) as! SearchListTableViewCell
        cell.productNameLabel.text = itemName[indexPath.row]
        cell.productImageView.image = UIImage(named: itemImage[0])
        cell.productPriceLabel.text = "US $"+String(itemPrice[indexPath.row])
        
        return cell
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
