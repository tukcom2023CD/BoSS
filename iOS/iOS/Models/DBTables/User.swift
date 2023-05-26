//
//  User.swift
//  iOS
//
//  Created by 이정동 on 2023/02/01.
//

import Foundation


struct UserData: Codable {
    var users: [User]
}

struct User: Codable {
    var uid: Int?
    var email: String?
    var name: String?
    var image_url : String?
}

