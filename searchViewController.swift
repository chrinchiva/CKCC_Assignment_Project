//
//  searchViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/26/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class searchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate{
    var productTitleArray = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5"]
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabel: UITableView!
    var productArray = [Products]() // to setup table
    var currentProductArray = [Products]()
    var ref: DatabaseReference!
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
       fetchUser()
        setProduct()
        setUpSearchBar()
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return currentProductArray.count
        return users.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         globalUserID = productTitleArray[indexPath.row]
        self.performSegue(withIdentifier: "segue_search_detail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell_search") as? searchTableViewCell else {
            return UITableViewCell()
        }
        
//        cell.labelName.text = currentProductArray[indexPath.row].category.rawValue
//        cell.productPrice.text = currentProductArray[indexPath.row].price
//        cell.imageViewProduct.image = UIImage(named: currentProductArray[indexPath.row].title)
        let user = users[indexPath.row]
        
        if let imageUrl = user.productImage {
            let imageUrl = URL(string: imageUrl)!
            
            let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let data = data {
                    print("the respone data is")
                    print(data)
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        cell.productPrice.text = user.price! + "$"
                        cell.labelName.text = user.title
                        self.productTitleArray[indexPath.row] = user.title!
                        print("My array product title is:",self.productTitleArray[indexPath.row])
                        if image != nil {
                            print("return true ")
                            cell.imageViewProduct.image = image
                            
                        } else {
                            print("return default ")
                            cell.imageViewProduct.image = #imageLiteral(resourceName: "default_image_select")
                            
                        }
                    }
                }
            }
            task.resume()
        }
        return cell
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            //currentProductArray = productArray
            //currentProductArray = productTitleArray
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
    func fetchUser(){

        // for a in 1...MyApp.shared.numberOfAllImage {
        Database.database().reference().child("AllimageInformation").observe(.childAdded, with: { (snapshot) in
            let user = User()
            let value = snapshot.value as? NSDictionary
            let userID = value?["UserID"] as? String ?? ""
            var productImage = value?["image"] as? String ?? ""
            var productTitle = value?["productTitle"] as? String ?? ""
            var price = value?["price"] as? String ?? ""
            // print("Username:",username,"email:",useremail,"Image:",productImage)
            
            user.productImage = productImage
            user.UserID = userID
            user.title = productTitle
            user.price = price
            //user.title = productTitle
//            user.username = username
//            user.price = price
//            user.phone = userphone
//            user.email = useremail
            self.users.append(user)
            
            DispatchQueue.main.async {
                self.tabel.reloadData()
            }
            
        }, withCancel: nil)
        // }
        //************************************
        
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
