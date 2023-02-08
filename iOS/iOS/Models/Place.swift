//
//  Place.swift
//  iOS
//
//  Created by 이정동 on 2023/01/26.
//

import Foundation

struct PlaceData: Codable {
    var places: [Place]
}

struct Place: Codable {
    var pid: Int?
    var name: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var category: String?
    var status: Int?
    var diary: String?
    var totalSpending: Int?
    var visitDate: String?
    var sid: Int?
    var uid: Int?
    
    enum CodingKeys: String, CodingKey {
        case pid, name, address, latitude, longitude, category, status, diary, sid, uid
        case totalSpending = "total_spending"
        case visitDate = "visit_date"
    }
    

    
    
    
    
    
    
}
