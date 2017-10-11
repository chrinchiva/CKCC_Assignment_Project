//
//  recentSearchViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/8/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class recentSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let recentlyProductImage = ["Nokia", "Iphone5"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentlyProductImage.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_recently_search", for: indexPath) as! recentlySearchTableViewCell
        cell.productImage.image = UIImage(named: recentlyProductImage[indexPath.row] + ".jpg")
        return cell
    }
    
}
