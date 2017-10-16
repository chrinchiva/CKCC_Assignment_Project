//
//  sellProductTableViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/14/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class sellProductTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
var productType = ["Phone", "Computer PC", "Clothes", "Laptop", "Bag", "Motor"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_seller_category") as! sellProductTableViewCell
        cell.titleOfCategoryLabel.text = productType[indexPath.row]
        cell.detailOfCategoryLabel.text = ">"
        return cell
    }

   

}
