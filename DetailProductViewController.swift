//
//  DetailProductViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/21/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DetailProductViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailCostLabel: UILabel!
    @IBOutlet weak var detailTotalLabel: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSeller: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelTel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labeDescription: UILabel!
    var ref : DatabaseReference!
    var total:Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAddCartNumber()
        print("User id global si:",globalUserID)
        loadinformation(imageID: globalUserID)
    }
    override func viewDidLayoutSubviews() {
        loadAddCartNumber()
        print("User id global si:",globalUserID)
        loadinformation(imageID: globalUserID)
    }
    func loadinformation(imageID:String){
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("AllimageInformation").child(imageID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let email  = value?["email"] as? String ?? ""
            let phone = value?["phone"] as? String ?? ""
            let price = value?["price"] as? String ?? ""
            let image = value?["image"] as? String ?? ""
            let title = value?["productTitle"] as? String ?? ""
            let description = value?["description"] as? String ?? ""
            
                let iimage = image
                    self.detailCostLabel.text = price + "$"
                   self.labelSeller.text = username
                   self.labelTel.text = phone
                    self.labelEmail.text = email
                    self.labelTitle.text = title
                    self.detailTotalLabel.text = "US$ " + price
                    self.labeDescription.text = description
            DispatchQueue.main.async {
                self.loadImagefromFirebaseDB(imageUrl: iimage)
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func loadImagefromFirebaseDB(imageUrl: String){
        let imageUrl = URL(string: imageUrl)!
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data {
                print("the respone data is")
                print(data)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    if image != nil {
                        print("return true ")
                        self.imageView.image = image
                    } else {
                        print("return default ")
                        self.imageView.image = #imageLiteral(resourceName: "default_image_select")
                    }
                }
            }
        }
        task.resume()
        
    }
    func loadAddCartNumber(){
        if Auth.auth().currentUser != nil {
            let uID = Auth.auth().currentUser?.uid
            ref = Database.database().reference()
            ref.child("userAddCart").child(uID!).child("addCartNumber").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! Int? ?? 0
                let result = value//Decimal(string: value)
                print("number add cart image:")
                print(value)
                let myApp = MyApp.shared
                myApp.addCartNumber = value // number of cart
                
            }){(error) in
                print(error.localizedDescription)
            }
        }else{
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_display_5_images", for: indexPath) as! DetailCollectionViewCell

            return cell
    }
    
    @IBAction func onClickAddtoCart(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            let uID = Auth.auth().currentUser?.uid
            let path1 = "userAddCart"
           ref = Database.database().reference()
            let newCartNumber = MyApp.shared.addCartNumber + 1
            let path2 = "image\(newCartNumber)"
            self.ref.child(path1).child(uID!).child("addCartNumber").setValue(newCartNumber)
            self.ref.child(path1).child(uID!).child("product").child(path2).setValue(globalUserID)


        } else {
            
        }
    }
    func loadProductImage(){
        let user = User()
        user.GlobalImage = globalImage
        
        if let imageUrl = user.GlobalImage {
            
            let imageUrl = URL(string: imageUrl)!
            let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let data = data {
                    print("the respone data is")
                    print(data)
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        if image != nil {
                            print("return true ")

                            self.imageView.image = image
                            
                        } else {
                            print("return default ")
                            self.imageView.image = #imageLiteral(resourceName: "default_image_select")
                            
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
