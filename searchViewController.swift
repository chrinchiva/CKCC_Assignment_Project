//
//  searchViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/26/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class searchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate{


    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabel: UITableView!
    var productArray = [Products]() // to setup table
    var currentProductArray = [Products]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setProduct()
        setUpSearchBar()
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentProductArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell_search") as? searchTableViewCell else {
            return UITableViewCell()
        }
        
        cell.labelName.text = currentProductArray[indexPath.row].category.rawValue
        cell.productPrice.text = currentProductArray[indexPath.row].price
        cell.imageViewProduct.image = UIImage(named: currentProductArray[indexPath.row].title)
        return cell
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentProductArray = productArray
             tabel.reloadData()
            return
            
        }
        currentProductArray = productArray.filter({ (product) -> Bool in
            product.title.contains(searchText)
            //return product.title.contains(text)
        })
        tabel.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    func setUpSearchBar(){
        
    }
    
    private func setProduct(){
        productArray.append(Products(title: "Image-1", price: "100$", category: .Computer))
        productArray.append(Products(title: "Image-2", price: "200$", category: .Computer))
        productArray.append(Products(title: "Image-3", price: "300$", category: .Computer))
        productArray.append(Products(title: "Image-4", price: "400$", category: .Phone))
        productArray.append(Products(title: "Image-5", price: "500$", category: .Phone))
        productArray.append(Products(title: "Image-6", price: "600$", category: .Phone))
        currentProductArray = productArray
    }
    

}
class Products {
    let title: String
    let price: String
    let category: ProductType
    init(title: String,price:String, category: ProductType){
        self.title = title
        self.price = price
        self.category = category
    }
}

enum ProductType: String {
    case Computer = "Computer"
    case Phone = "Phone"
}
