//
//  CartViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/8/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var ref:DatabaseReference!
    @IBOutlet weak var tableView1: UITableView!
    var users2 = [User]()
    var cartImageName = [String]()
    var databaseHandle : DatabaseHandle!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView1.delegate = self
        tableView1.dataSource = self
       fetchCartData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartImageName.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print("you have select:", cartImageName[indexPath.row])
        globalUserID = cartImageName[indexPath.row]
        performSegue(withIdentifier: "segue_history_to_detail", sender: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_cart", for: indexPath) as! ViewcontrolllerCartTableViewCell
      //  cell.productCost.text = String(costList[indexPath.row])
       // cell.sellerName.text = sellerNameList[indexPath.row]
        //cell.productImage.image = UIImage(named: String(ImageList[indexPath.row] ) + ".jpg")
       // cell.productImage.image = UIImage(named: "Iphone5.jpg")
        
        cell.productName.text = cartImageName[indexPath.row]
        // ************************************************************
        let userID = Auth.auth().currentUser?.uid
        let imageID = cartImageName[indexPath.row]
        ref = Database.database().reference()
        ref.child("AllimageInformation").child(imageID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let image = value?["image"] as? String ?? ""
            let seller = value?["username"]as? String ?? ""
            let price = value?["price"]as? String ?? ""
            let title = value?["productTitle"]as? String ?? ""
            
            let iimage = image
            print("Data receive is:", iimage)
            cell.productCost.text = price
            cell.productName.text = title
            cell.sellerName.text = seller
            DispatchQueue.main.async {
                let imageUrl = URL(string: iimage)!
                let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                    if let data = data {
                        print("the respone data is")
                        print(data)
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            if image != nil {
                                cell.productImage.image = image
                            } else {
                                print("return default ")
                                cell.productImage.image  = #imageLiteral(resourceName: "default_image_select")
                            }
                        }
                    }
                }
                task.resume()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        // ************************************************************
        
        
        return cell
   
    }

    func fetchCartData(){
        ref = Database.database().reference()
        if Auth.auth().currentUser != nil {
            let uID = Auth.auth().currentUser?.uid
            databaseHandle = ref.child("userAddCart").child(uID!).child("product").observe(.childAdded, with: { (snapshot) in
                
                let post = snapshot.value as? String
                //print("post image is:", post)
                if let actualPos = post {
                    self.cartImageName.append(actualPos)
                    self.tableView1.reloadData()
                }
                
            })
        }
        
    }
    

}
