//
//  CartViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/8/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
        
    var sellerNameList = ["Seller1", "Seller2", "Seller3", "Seller4","Seller5", "Seller6", "Seller7", "Seller8","Seller9", "Seller10"]
    var costList = [120,100,200,120,300,400,820,700,210,120]
    var ImageList = ["1","2","3","4"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellerNameList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_cart", for: indexPath) as! ViewcontrolllerCartTableViewCell
        cell.productCost.text = String(costList[indexPath.row])
        cell.sellerName.text = sellerNameList[indexPath.row]
        //cell.productImage.image = UIImage(named: String(ImageList[indexPath.row] ) + ".jpg")
        cell.productImage.image = UIImage(named: "Iphone5.jpg")
        return cell
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
