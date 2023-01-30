//
//  Schedule.swift
//  iOS
//
//  Created by 이정동 on 2023/01/30.
//

import Foundation


struct ScheduleData: Codable {
    var schedules: [Schedule]
}

struct Schedule: Codable {
    var sid: Int?
    var title: String?
    var region: String?
    var start: String?
    var stop: String?
    var uid: Int?
}
