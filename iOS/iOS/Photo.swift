//
//  Photo.swift
//  iOS
//
//  Created by 이정동 on 2023/02/21.
//

import Foundation


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
