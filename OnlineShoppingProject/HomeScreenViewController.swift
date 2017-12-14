//
//  HomeScreenViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/8/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase

// customer information
var homeIndex: Int = 0
var title=["iPhone5","Computer Dell"]
var newImage:[String] = ["5","6","7","8","9","10","11","12","13","14","Nokia","Iphone5"]
var name=["Chrin Chiva","Ngoun Rithy"]
var email=["chivachrin@gmail.com","Rithy@gmail.com"]
var username=["chrinchiva","nhounrithy"]
var password=["123","123"]
var telephone1=["010767276","086266007"]
var telephone2=["",""]
var cost=[120.0,100.0,300.0,150.0]
var id=["1","2","3"]
var address=["kakab, pour senchey","chomka mon, sensok"]
var newOrold=[true,false]
var description=["ផលិតផលនេះត្រូវបានប្រើចាប់តាំងពីខែមករាឆ្នាំ២០១៦​, នូវថ្មី%","ផលិតផលនេះត្រូវបានប្រើចាប់តាំងពីខែមករាឆ្នាំ២០១៥, នូវថ្មី៥០%"]
var image1:[String] = ["5","6"]
var image2:[String] = ["","7"]
var image3:[String]=["7","8"]
var image4:[String]=["8","9"]
var image5:[String]=["9","10"]
var shipping=[0.00,0.50,0.00,1.00,0.00]
var category=["Phone", "Computer PC", "Clothes", "Laptop", "Bag", "Motor"]
 var province:[String] = ["Phnom Penh","Sihanouk","Takeo","Kandal","Battombong","Prey Veng","Kom Pong Speu","Svay Reang","Phnom Penh","Sihanouk","Takeo","Kandal","Battombong","Prey Veng","Kom Pong Speu","Svay Reang"]
var date=[Date(),Date()]
//
class HomeScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerPageController: UIPageControl!
    var timer: Timer!
    var updateCounter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCounter = 0
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(HomeScreenViewController.updateTimer), userInfo: nil, repeats: true)
    }
    func updateTimer() {
        if(updateCounter <= 3){
            bannerPageController.currentPage = updateCounter
            bannerImageView.image = UIImage(named: String(updateCounter+1) + ".jpg")
            updateCounter = updateCounter+1
            
        }
        else{
            updateCounter = 0
        }
    }

    // collection data view of new product 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image1.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_newproduct", for: indexPath) as! newProductCollectionViewCell
        //cell.newProductImageView.image = UIImage(named: image1[indexPath.row] + ".jpg")
        cell.newProductImageView.image = UIImage(named: image1[indexPath.row] + ".jpg")
        let viewCost = cost[indexPath.row]
      cell.newProductlabelView.text = "US $\(viewCost)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeIndex = indexPath.row
        performSegue(withIdentifier: "segue_homedetail", sender: self)
    }
    
}
