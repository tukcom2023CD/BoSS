//
//  Photo.swift
//  iOS
//
//  Created by 이정동 on 2023/02/21.
//

import Foundation
import UIKit


struct PhotoData: Codable {
    var photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case photos = "url"
    }
}

struct Photo: Codable {
    var phid: Int
    var imageUrl: String
    var uid: Int
    var pid: Int
    
    enum CodingKeys: String, CodingKey {
        case phid, uid, pid
        case imageUrl = "url"
    }
}

struct PhotoWithCategoryData: Codable {
    var PhotoWithCategories: [PhotoWithCategory]
    
    enum CodingKeys: String, CodingKey {
        case PhotoWithCategories = "url"
    }
}

struct PhotoWithCategory: Codable {
    var category_name: String
    var phid: Int
    var uid: Int
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case phid, uid, category_name
        case imageUrl = "url"
    }
}

struct ImageData {
    var image: UIImage
    var isAdded: Bool = false
    var isDeleted: Bool = false
    var imageUrl: String?
}
