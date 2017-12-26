//
//  searchTableViewCell.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/26/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class searchTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var imageViewProduct: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
