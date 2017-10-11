//
//  SearchHistoryViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/8/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class SearchHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
var myIndex = 0
        var data = ["SEARCH HISTORY", "History product 01", "History Product 03","History Product 04", "History Product 05", "History Product 06","History Product 07", "History Product 08", "History Product 09","History Product 10"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell_search_history")
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "cell_categories_viewdetail", sender: self)
    }
    
}
