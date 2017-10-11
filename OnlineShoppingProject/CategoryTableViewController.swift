//
//  CategoryTableViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/9/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController{
    var productType = ["Phone", "Computer PC", "Clothes", "Laptop", "Bag", "Motor"]
    var indexTableSelect = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return productType.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_category", for: indexPath) as! CategoryTableViewCell
        cell.categoryImageView.image = UIImage(named: "iconPhone.png")
        cell.categoryNameLabel.text = productType[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexTableSelect = indexPath.row
        performSegue(withIdentifier: "seque_cart_viewdetail", sender: self)
    }


}
