//
//  Article.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 10/25/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import Foundation

struct Article:Decodable {
    let id: Int
    let title: String
    let content: String
    let imageUrl: String
    let date: String
    let author: String
    let viewCount: Int
    private enum CodingKeys: String, CodingKey{
        case id = "_id"
        case title = "_title"
        case content = "_content"
        case imageUrl = "_imageUrl"
        case date = "_date"
        case author = "_author"
        case viewCount = "_viewCount"
    }
}
