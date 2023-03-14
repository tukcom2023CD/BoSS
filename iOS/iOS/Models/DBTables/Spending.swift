//
//  Spending.swift
//  iOS
//
//  Created by 이정동 on 2023/02/21.
//

import Foundation

struct SpendingData: Codable {
    var spendings: [Spending]
}

struct Spending: Codable {
    var spid: Int?
    var name: String?
    var quantity: Int?
    var price: Int?
    var pid: Int?
}



