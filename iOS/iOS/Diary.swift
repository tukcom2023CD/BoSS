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
//영수증 데이터구조체: 품명, 수량, 가격
struct AllData {
    var itemData:String
    var amountData:String
    var priceData:String
    
    init(itemData:String, amountData:String, priceData:String) {
        self.itemData = itemData
        self.amountData = amountData
        self.priceData = priceData
    }
}



