//
//  MainPlanData.swift
//  iOS
//
//  Created by 박다미 on 2023/01/30.
//

import UIKit

struct Notice{
    let date: String
    let title: String
    let content: String
    var open = false
    
    mutating func dateFormat() -> String{
        guard let s = self.date.split(separator: " ").first else {return "??"}
        
        return String(s)
    }
}
