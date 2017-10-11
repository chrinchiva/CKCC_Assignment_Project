//
//  newExampleViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/11/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class newExampleViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource{
    var arrayImage:[String] = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_example", for: indexPath) as! newCollectionViewCell
        cell.imageViewCell.image = UIImage(named: arrayImage[indexPath.row]+".jpg")
        return cell
    }

}
