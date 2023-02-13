//
//  Diary.swift
//  iOS
//
//  Created by 박다미 on 2023/02/13.
//

import Foundation
import UIKit
protocol MemberDelegate: AnyObject {
    func update(_ diary: Diary)
    
}
struct Diary {
    var imageCard: UIImage?
    let contents: String?
    init(imageCard: UIImage? = nil, contents: String?) {
        self.imageCard = imageCard
        self.contents = contents
    }

}
