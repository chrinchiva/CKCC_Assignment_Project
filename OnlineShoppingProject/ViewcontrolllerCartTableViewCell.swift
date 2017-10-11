//
//  ViewcontrolllerCartTableViewCell.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/8/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class ViewcontrolllerCartTableViewCell: UITableViewCell {

    
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCost: UILabel!
    @IBOutlet weak var QtyProduct: UILabel!

    var num = 0
    @IBAction func StateSelectProduct(_ sender: Any) {
    
    }
    @IBAction func onClickMinusButton(_ sender: Any) {
        num = num-1
        if ( num < 0){
          num = 0
        }
        QtyProduct.text = String(num)
    }
    @IBAction func onClickAddButton(_ sender: Any) {
        num = num+1
        if ( num > 10){
            num = 10
        }
        QtyProduct.text = String(num)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
