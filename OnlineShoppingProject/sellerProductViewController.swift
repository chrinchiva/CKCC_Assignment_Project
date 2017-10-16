//
//  sellerProductViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/15/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class sellerProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var productType:[String] = ["Phone", "Computer PC", "Clothes", "Laptop", "Bag", "Motor"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_seller_category", for: indexPath) as! sellProductTableViewCell
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell_seller_category")
        cell.labelCategory.text = productType[indexPath.row]
        return cell
    }
    
}
