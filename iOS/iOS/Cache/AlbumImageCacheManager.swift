//
//  AlbumImageCacheManager.swift
//  iOS
//
//  Created by JunHee on 2023/02/24.
//

import UIKit

class AlbumImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init () {}
}
