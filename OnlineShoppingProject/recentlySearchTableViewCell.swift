//
//  recentlySearchTableViewCell.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/8/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class recentlySearchTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UIStackView!
    @IBOutlet weak var productType: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
