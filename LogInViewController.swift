//
//  LogInViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/15/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(r: 0, g: 151, b: 155)
        
        let inputsContainerView = UIView()
        inputsContainerView.backgroundColor = UIColor.white
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputsContainerView)
        // need x, y, height constrains
        //inputsContainerView.centerXAnchor.constainEquaToAnchor(view.centerXAnchor).active = true
        if #available(iOS 11.0, *) {
            inputsContainerView.centerXAnchor.constraintEqualToSystemSpacingAfter(view.centerXAnchor, multiplier: 0)
            inputsContainerView.centerYAnchor.constraintEqualToSystemSpacingBelow(view.centerYAnchor, multiplier: 0)
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: -24)
            
        } else {
            // Fallback on earlier versions
        }
        
    }

}

    //extension UIColor {
    //    convenience init(r: CGFloat, g:CGFloat, b: CGFloat) {
    //        self.init   (red: r/255, green: g/255, blue: b/255, alpha: 1)
    //    }
    //}

