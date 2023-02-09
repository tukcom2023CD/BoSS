//
//  WriteDetailSection.swift
//  iOS
//
//  Created by 박다미 on 2023/02/09.
//
import UIKit
import Foundation

class DetailSection {
    let title: String
    let options: [String]
    var isOpend: Bool = false
    
    init(title: String,
         options: [String],
         isOpend: Bool = false){
        
        self.title = title
        self.options = options
        self.isOpend = isOpend
    }
}
