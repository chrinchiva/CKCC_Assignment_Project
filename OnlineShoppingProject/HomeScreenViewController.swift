//
//  HomeScreenViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/8/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerPageController: UIPageControl!
    var timer: Timer!
    var updateCounter: Int!
    var newImage:[String] = ["5","6","7","8","9","10","11","12","13","14","Nokia","Iphone5"]
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
        return newImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_newproduct", for: indexPath) as! newProductCollectionViewCell
        cell.newProductImageView.image = UIImage(named: newImage[indexPath.row]+".jpg")
        cell.newProductlabelView.text = "US $"+String(350*indexPath.row)
        return cell
    }
    
}
