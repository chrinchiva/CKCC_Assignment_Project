//
//  DetailProductViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/21/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class DetailProductViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailCostLabel: UILabel!
    @IBOutlet weak var detailTotalLabel: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSeller: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelTel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //var cost1=cost[homeIndex]
    //var cost2=shipping[homeIndex]
    var total:Double = 0
    //var imageGet=[image1[homeIndex],image2[homeIndex],image3[homeIndex],image4[homeIndex],image5[homeIndex]]
    override func viewDidLoad() {
        super.viewDidLoad()
        detailCostLabel.text = globalPrice + "$"
        labelSeller.text = globalUser
        labelTel.text = globalPhone
        labelEmail.text = globaEmail
        labelTitle.text = globalTitle
        detailTotalLabel.text = "US$ " + globalPrice
        loadProductImage()
        // total = cost1 + cost2
       // detailCostLabel.text = "US $"+String(cost[homeIndex])
        //detailTotalLabel.text = "US $\(cost[homeIndex] + shipping[homeIndex])"//+String(total)
        //detailImageView.image = UIImage(named: image1[homeIndex] + ".jpg")
        // Do any additional setup after loading the view.
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
//        if (imageGet[indexPath.row] == ""){
//            cell.DetailImageView5_images.image = UIImage(named: "blankImage.svg")
//        }
//        else{
//            cell.DetailImageView5_images.image = UIImage(named: imageGet[indexPath.row] + ".jpg")
//        }
            return cell
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
