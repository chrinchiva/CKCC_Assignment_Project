//
//  User.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/24/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import Foundation

//class User{
//var postID: String
//var profilePic: String
//var username: String
//var postImage: String
//var timestamp: NSNumber
//
//init( postID: String, profilePic: String, username:String, postImage:String, timestamp:NSNumber){
//    self.postID = postID
//    self.profilePic = profilePic
//    self.username = username
//    self.postImage = postImage
//    self.timestamp = timestamp
//}
//func returnPostAsDictionary()->NSDictionary{
//    let postDictionary: NSDictionary = ["postID": postID,
//                                        "image": profilePic,
//                                        "username": username,
//                                        "posted_pic": postImage,
//                                        "timestamp": timestamp]
//    return postDictionary
//}
//}
class User: NSObject {
    var username: String?
    var email: String?
    var profileImageUrl : String?
    //var profileImage = [String]()
    var productImage : String?
    var price: String?
    var phone: String?
    var title:String?
    var GlobalImage:String?
    
}


